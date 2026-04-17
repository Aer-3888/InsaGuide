"""
TP 3-4: Détection et Caractérisation de Points d'Intérêt (POI) à Rennes
Auteur: ADFD - INSA Rennes 3INFO
Description: Analyse spatiale de données Flickr pour identifier les POI de Rennes
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.cluster import DBSCAN, KMeans
from sklearn.metrics import silhouette_score, davies_bouldin_score
from collections import Counter
import warnings

warnings.filterwarnings('ignore')

# Configuration
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")


class POIDetection:
    """Classe pour la détection et caractérisation de POI à partir de données Flickr"""

    def __init__(self, data_file=None):
        """
        Initialise l'analyse

        Args:
            data_file: Chemin vers le fichier CSV contenant les données Flickr
        """
        self.df = None
        self.df_clean = None
        self.coords_cartesian = None
        self.clusters_dbscan = None
        self.clusters_kmeans = None
        self.poi_stats = None

        if data_file:
            self.load_data(data_file)

    def load_data(self, file_path):
        """
        Charge les données depuis un fichier CSV

        Args:
            file_path: Chemin vers le fichier CSV
        """
        print(f"Chargement des données depuis {file_path}...")
        self.df = pd.read_csv(file_path)
        print(f"Données chargées: {len(self.df)} photos")
        print(f"Colonnes: {list(self.df.columns)}")

    def create_sample_data(self, n_photos=1000):
        """
        Crée un jeu de données d'exemple centré sur Rennes

        Args:
            n_photos: Nombre de photos à générer
        """
        print(f"Création de données d'exemple ({n_photos} photos)...")

        # Coordonnées de Rennes (centre-ville)
        rennes_center = (48.1173, -1.6778)

        # Définition de POI fictifs autour de Rennes
        poi_centers = [
            (48.1113, -1.6797, 200, "Parlement de Bretagne"),  # Centre historique
            (48.1207, -1.6710, 150, "Parc du Thabor"),
            (48.1050, -1.6752, 100, "Les Champs Libres"),
            (48.1140, -1.6840, 80, "Place Sainte-Anne"),
            (48.1095, -1.6742, 120, "Cathédrale Saint-Pierre"),
            (48.1189, -1.6889, 60, "Parc des Gayeulles"),
            (48.1060, -1.6680, 90, "Opéra de Rennes"),
        ]

        photos = []
        photo_id = 1

        for center_lat, center_lon, n_photos_poi, poi_name in poi_centers:
            # Nombre d'utilisateurs pour ce POI
            n_users = max(5, n_photos_poi // 3)

            for _ in range(n_photos_poi):
                # Dispersion autour du centre (écart-type = 0.002° ≈ 200m)
                lat = np.random.normal(center_lat, 0.002)
                lon = np.random.normal(center_lon, 0.002)

                # User ID (certains utilisateurs prennent plusieurs photos)
                user_id = f"user_{np.random.randint(1, n_users + 1)}"

                # Date aléatoire en 2019
                date_taken = f"2019-{np.random.randint(1, 13):02d}-{np.random.randint(1, 29):02d}"

                # Tags (simulés)
                tags = self._generate_tags(poi_name)

                photos.append({
                    'photo_id': photo_id,
                    'user_id': user_id,
                    'latitude': lat,
                    'longitude': lon,
                    'date_taken': date_taken,
                    'title': f"Photo at {poi_name}",
                    'tags': tags,
                    'views': np.random.randint(10, 1000)
                })

                photo_id += 1

        # Ajout de bruit (photos dispersées)
        n_noise = int(n_photos * 0.1)
        for _ in range(n_noise):
            lat = np.random.uniform(48.05, 48.15)
            lon = np.random.uniform(-1.75, -1.60)

            photos.append({
                'photo_id': photo_id,
                'user_id': f"user_{np.random.randint(1, 100)}",
                'latitude': lat,
                'longitude': lon,
                'date_taken': f"2019-{np.random.randint(1, 13):02d}-{np.random.randint(1, 29):02d}",
                'title': "Random photo",
                'tags': "rennes,bretagne",
                'views': np.random.randint(5, 50)
            })

            photo_id += 1

        self.df = pd.DataFrame(photos)
        print(f"Données d'exemple créées: {len(self.df)} photos")

    def _generate_tags(self, poi_name):
        """Génère des tags basés sur le nom du POI"""
        base_tags = ["rennes", "bretagne", "france"]

        poi_tags = {
            "Parlement de Bretagne": ["architecture", "historical", "building", "monument"],
            "Parc du Thabor": ["park", "garden", "nature", "green"],
            "Les Champs Libres": ["museum", "library", "culture", "modern"],
            "Place Sainte-Anne": ["square", "nightlife", "bars", "people"],
            "Cathédrale Saint-Pierre": ["cathedral", "church", "religious", "architecture"],
            "Parc des Gayeulles": ["park", "sport", "nature", "recreation"],
            "Opéra de Rennes": ["opera", "theatre", "culture", "performance"],
        }

        specific_tags = poi_tags.get(poi_name, ["city", "urban"])
        all_tags = base_tags + np.random.choice(specific_tags, size=2, replace=False).tolist()

        return ",".join(all_tags)

    def explore_data(self):
        """Explore et affiche les statistiques descriptives"""
        if self.df is None:
            print("Erreur: Chargez d'abord les données")
            return

        print("\n=== EXPLORATION DES DONNÉES ===")
        print(f"\nNombre total de photos: {len(self.df)}")
        print(f"Nombre d'utilisateurs uniques: {self.df['user_id'].nunique()}")

        print("\nPremières lignes:")
        print(self.df.head())

        print("\nStatistiques des coordonnées:")
        print(self.df[['latitude', 'longitude']].describe())

        # Distribution temporelle
        if 'date_taken' in self.df.columns:
            self.df['date_taken'] = pd.to_datetime(self.df['date_taken'])
            print("\nDistribution temporelle:")
            print(self.df['date_taken'].describe())

    def preprocess_data(self):
        """Prétraite les données (nettoyage, déduplication, conversion)"""
        if self.df is None:
            print("Erreur: Chargez d'abord les données")
            return

        print("\n=== PRÉTRAITEMENT DES DONNÉES ===")

        # 1. Copie des données
        self.df_clean = self.df.copy()
        initial_count = len(self.df_clean)

        # 2. Suppression des valeurs manquantes
        self.df_clean = self.df_clean.dropna(subset=['latitude', 'longitude', 'user_id'])
        print(f"Suppression des NaN: {initial_count} → {len(self.df_clean)} photos")

        # 3. Déduplication (même utilisateur, même localisation)
        # Arrondir les coordonnées pour détecter les duplicatas (précision ~10m)
        self.df_clean['lat_round'] = self.df_clean['latitude'].round(4)
        self.df_clean['lon_round'] = self.df_clean['longitude'].round(4)
        self.df_clean = self.df_clean.drop_duplicates(
            subset=['user_id', 'lat_round', 'lon_round']
        )
        print(f"Déduplication: {len(self.df)} → {len(self.df_clean)} photos")

        # 4. Filtrage géographique (bounding box Rennes)
        # Rennes: lat 48.0-48.2, lon -1.8 à -1.6
        self.df_clean = self.df_clean[
            (self.df_clean['latitude'] >= 48.0) &
            (self.df_clean['latitude'] <= 48.2) &
            (self.df_clean['longitude'] >= -1.8) &
            (self.df_clean['longitude'] <= -1.6)
        ]
        print(f"Filtrage géographique: {len(self.df_clean)} photos dans la bounding box")

        # 5. Conversion GPS → Coordonnées cartésiennes (approximation simple)
        # Pour des distances précises, utiliser pyproj avec Lambert 93
        # Ici, approximation: 1° latitude ≈ 111 km, 1° longitude ≈ 71 km (à 48°N)
        self.df_clean['x'] = (self.df_clean['longitude'] + 1.7) * 71000  # mètres
        self.df_clean['y'] = (self.df_clean['latitude'] - 48.0) * 111000  # mètres

        self.coords_cartesian = self.df_clean[['x', 'y']].values

        print(f"\nDonnées prétraitées: {len(self.df_clean)} photos")
        print(f"Coordonnées cartésiennes calculées (x, y en mètres)")

    def plot_spatial_distribution(self):
        """Visualise la distribution spatiale des photos"""
        if self.df_clean is None:
            print("Erreur: Prétraitez d'abord les données")
            return

        fig, axes = plt.subplots(1, 2, figsize=(16, 7))

        # Scatter plot
        axes[0].scatter(self.df_clean['longitude'], self.df_clean['latitude'],
                       s=10, alpha=0.5, c='steelblue')
        axes[0].set_xlabel('Longitude', fontsize=12)
        axes[0].set_ylabel('Latitude', fontsize=12)
        axes[0].set_title('Distribution spatiale des photos (GPS)', fontsize=14)
        axes[0].grid(alpha=0.3)

        # Heatmap
        axes[1].hist2d(self.df_clean['longitude'], self.df_clean['latitude'],
                      bins=50, cmap='YlOrRd')
        axes[1].set_xlabel('Longitude', fontsize=12)
        axes[1].set_ylabel('Latitude', fontsize=12)
        axes[1].set_title('Carte de densité (heatmap)', fontsize=14)
        plt.colorbar(axes[1].collections[0], ax=axes[1], label='Nombre de photos')

        plt.tight_layout()
        plt.savefig('spatial_distribution.png', dpi=300, bbox_inches='tight')
        print("Distribution spatiale sauvegardée: spatial_distribution.png")

    def determine_optimal_eps(self, k=5):
        """
        Détermine le paramètre eps optimal via k-distance graph

        Args:
            k: Nombre de voisins (généralement min_samples - 1)
        """
        if self.coords_cartesian is None:
            print("Erreur: Prétraitez d'abord les données")
            return

        print(f"\n=== DÉTERMINATION DU PARAMÈTRE EPS (K-DISTANCE GRAPH) ===")

        from sklearn.neighbors import NearestNeighbors

        # Calcul des k plus proches voisins
        neighbors = NearestNeighbors(n_neighbors=k)
        neighbors.fit(self.coords_cartesian)
        distances, indices = neighbors.kneighbors(self.coords_cartesian)

        # Distance au k-ième voisin
        k_distances = distances[:, -1]
        k_distances_sorted = np.sort(k_distances)

        # Visualisation
        plt.figure(figsize=(10, 6))
        plt.plot(k_distances_sorted, linewidth=2)
        plt.xlabel('Points triés', fontsize=12)
        plt.ylabel(f'Distance au {k}-ième voisin (mètres)', fontsize=12)
        plt.title(f'K-distance Graph (k={k})', fontsize=14)
        plt.grid(alpha=0.3)

        # Suggestion d'eps (coude de la courbe)
        # Heuristique: prendre le 95e percentile
        suggested_eps = np.percentile(k_distances_sorted, 95)
        plt.axhline(y=suggested_eps, color='r', linestyle='--',
                   label=f'Suggestion eps = {suggested_eps:.0f}m')
        plt.legend()

        plt.tight_layout()
        plt.savefig('k_distance_graph.png', dpi=300, bbox_inches='tight')
        print(f"K-distance graph sauvegardé: k_distance_graph.png")
        print(f"Valeur eps suggérée: {suggested_eps:.0f} mètres")

        return suggested_eps

    def apply_dbscan(self, eps=100, min_samples=10):
        """
        Applique l'algorithme DBSCAN

        Args:
            eps: Rayon de voisinage (en mètres)
            min_samples: Nombre minimum de points pour former un cluster
        """
        if self.coords_cartesian is None:
            print("Erreur: Prétraitez d'abord les données")
            return

        print(f"\n=== CLUSTERING DBSCAN ===")
        print(f"Paramètres: eps={eps}m, min_samples={min_samples}")

        # Application DBSCAN
        dbscan = DBSCAN(eps=eps, min_samples=min_samples, metric='euclidean')
        self.clusters_dbscan = dbscan.fit_predict(self.coords_cartesian)

        # Ajout au DataFrame
        self.df_clean['cluster_dbscan'] = self.clusters_dbscan

        # Statistiques
        n_clusters = len(set(self.clusters_dbscan)) - (1 if -1 in self.clusters_dbscan else 0)
        n_noise = list(self.clusters_dbscan).count(-1)

        print(f"\nRésultats:")
        print(f"  Nombre de clusters: {n_clusters}")
        print(f"  Points de bruit: {n_noise} ({n_noise/len(self.clusters_dbscan)*100:.1f}%)")

        # Distribution de la taille des clusters
        cluster_sizes = Counter(self.clusters_dbscan)
        del cluster_sizes[-1]  # Retirer le bruit

        print(f"\nTaille des clusters:")
        for cluster_id, size in sorted(cluster_sizes.items(), key=lambda x: x[1], reverse=True)[:10]:
            print(f"  Cluster {cluster_id}: {size} photos")

        return self.clusters_dbscan

    def apply_kmeans(self, n_clusters=10):
        """
        Applique l'algorithme K-means pour comparaison

        Args:
            n_clusters: Nombre de clusters
        """
        if self.coords_cartesian is None:
            print("Erreur: Prétraitez d'abord les données")
            return

        print(f"\n=== CLUSTERING K-MEANS ===")
        print(f"Paramètres: n_clusters={n_clusters}")

        # Application K-means
        kmeans = KMeans(n_clusters=n_clusters, random_state=42, n_init=10)
        self.clusters_kmeans = kmeans.fit_predict(self.coords_cartesian)

        # Ajout au DataFrame
        self.df_clean['cluster_kmeans'] = self.clusters_kmeans

        # Statistiques
        print(f"\nRésultats:")
        print(f"  Nombre de clusters: {n_clusters}")

        # Distribution de la taille des clusters
        cluster_sizes = Counter(self.clusters_kmeans)

        print(f"\nTaille des clusters:")
        for cluster_id, size in sorted(cluster_sizes.items(), key=lambda x: x[1], reverse=True):
            print(f"  Cluster {cluster_id}: {size} photos")

        return self.clusters_kmeans

    def compare_methods(self):
        """Compare DBSCAN et K-means"""
        if self.clusters_dbscan is None or self.clusters_kmeans is None:
            print("Erreur: Appliquez d'abord DBSCAN et K-means")
            return

        print("\n=== COMPARAISON DBSCAN VS K-MEANS ===")

        # Métriques (ignorer le bruit pour DBSCAN)
        mask_no_noise = self.clusters_dbscan != -1

        # Silhouette score
        sil_dbscan = silhouette_score(self.coords_cartesian[mask_no_noise],
                                      self.clusters_dbscan[mask_no_noise])
        sil_kmeans = silhouette_score(self.coords_cartesian,
                                      self.clusters_kmeans)

        # Davies-Bouldin index
        db_dbscan = davies_bouldin_score(self.coords_cartesian[mask_no_noise],
                                         self.clusters_dbscan[mask_no_noise])
        db_kmeans = davies_bouldin_score(self.coords_cartesian,
                                         self.clusters_kmeans)

        print("\nMétriques:")
        print(f"  Silhouette Score:")
        print(f"    DBSCAN: {sil_dbscan:.4f}")
        print(f"    K-means: {sil_kmeans:.4f}")
        print(f"    → Plus élevé = meilleur ([-1, 1])")

        print(f"\n  Davies-Bouldin Index:")
        print(f"    DBSCAN: {db_dbscan:.4f}")
        print(f"    K-means: {db_kmeans:.4f}")
        print(f"    → Plus faible = meilleur (≥0)")

        # Visualisation comparative
        fig, axes = plt.subplots(1, 2, figsize=(16, 7))

        # DBSCAN
        scatter = axes[0].scatter(self.df_clean['longitude'],
                                 self.df_clean['latitude'],
                                 c=self.clusters_dbscan,
                                 cmap='tab20',
                                 s=20,
                                 alpha=0.6)
        axes[0].set_xlabel('Longitude', fontsize=12)
        axes[0].set_ylabel('Latitude', fontsize=12)
        axes[0].set_title(f'DBSCAN (Silhouette: {sil_dbscan:.3f})', fontsize=14)
        plt.colorbar(scatter, ax=axes[0], label='Cluster ID')

        # K-means
        scatter = axes[1].scatter(self.df_clean['longitude'],
                                 self.df_clean['latitude'],
                                 c=self.clusters_kmeans,
                                 cmap='tab20',
                                 s=20,
                                 alpha=0.6)
        axes[1].set_xlabel('Longitude', fontsize=12)
        axes[1].set_ylabel('Latitude', fontsize=12)
        axes[1].set_title(f'K-means (Silhouette: {sil_kmeans:.3f})', fontsize=14)
        plt.colorbar(scatter, ax=axes[1], label='Cluster ID')

        plt.tight_layout()
        plt.savefig('comparison_dbscan_kmeans.png', dpi=300, bbox_inches='tight')
        print("\nComparaison visuelle sauvegardée: comparison_dbscan_kmeans.png")

    def characterize_poi(self, method='dbscan', top_n=10):
        """
        Caractérise les POI identifiés

        Args:
            method: Méthode de clustering ('dbscan' ou 'kmeans')
            top_n: Nombre de POI à analyser en détail
        """
        if method == 'dbscan' and self.clusters_dbscan is None:
            print("Erreur: Appliquez d'abord DBSCAN")
            return
        elif method == 'kmeans' and self.clusters_kmeans is None:
            print("Erreur: Appliquez d'abord K-means")
            return

        print(f"\n=== CARACTÉRISATION DES POI ({method.upper()}) ===")

        clusters = self.clusters_dbscan if method == 'dbscan' else self.clusters_kmeans

        # Statistiques par cluster
        poi_stats = []

        unique_clusters = sorted(set(clusters))
        if method == 'dbscan' and -1 in unique_clusters:
            unique_clusters.remove(-1)  # Ignorer le bruit

        for cluster_id in unique_clusters:
            cluster_data = self.df_clean[self.df_clean[f'cluster_{method}'] == cluster_id]

            stats = {
                'cluster_id': cluster_id,
                'n_photos': len(cluster_data),
                'n_users': cluster_data['user_id'].nunique(),
                'center_lat': cluster_data['latitude'].mean(),
                'center_lon': cluster_data['longitude'].mean(),
                'radius_m': np.sqrt(
                    ((cluster_data['x'] - cluster_data['x'].mean()) ** 2 +
                     (cluster_data['y'] - cluster_data['y'].mean()) ** 2).mean()
                ),
                'density': len(cluster_data) / (np.pi * (np.sqrt(
                    ((cluster_data['x'] - cluster_data['x'].mean()) ** 2 +
                     (cluster_data['y'] - cluster_data['y'].mean()) ** 2).mean()
                ) / 1000) ** 2 + 0.01),  # photos/km²
                'photos_per_user': len(cluster_data) / cluster_data['user_id'].nunique(),
            }

            # Tags les plus fréquents
            if 'tags' in cluster_data.columns:
                all_tags = []
                for tags_str in cluster_data['tags'].dropna():
                    all_tags.extend(tags_str.split(','))
                tag_counts = Counter(all_tags)
                stats['top_tags'] = ', '.join([tag for tag, count in tag_counts.most_common(5)])

            poi_stats.append(stats)

        self.poi_stats = pd.DataFrame(poi_stats)
        self.poi_stats = self.poi_stats.sort_values('n_photos', ascending=False)

        # Affichage des top POI
        print(f"\nTop {top_n} POI par nombre de photos:")
        print("="*100)

        for idx, row in self.poi_stats.head(top_n).iterrows():
            print(f"\nPOI #{row['cluster_id']}:")
            print(f"  Position: {row['center_lat']:.6f}, {row['center_lon']:.6f}")
            print(f"  Nombre de photos: {row['n_photos']}")
            print(f"  Utilisateurs uniques: {row['n_users']}")
            print(f"  Photos/utilisateur: {row['photos_per_user']:.2f}")
            print(f"  Rayon: {row['radius_m']:.0f} mètres")
            print(f"  Densité: {row['density']:.1f} photos/km²")
            if 'top_tags' in row:
                print(f"  Tags principaux: {row['top_tags']}")

        # Sauvegarde CSV
        self.poi_stats.to_csv(f'poi_stats_{method}.csv', index=False)
        print(f"\nStatistiques POI sauvegardées: poi_stats_{method}.csv")

        return self.poi_stats

    def plot_poi_map(self, method='dbscan', top_n=10):
        """
        Visualise les POI sur une carte

        Args:
            method: Méthode de clustering
            top_n: Nombre de POI à afficher
        """
        if self.poi_stats is None:
            self.characterize_poi(method=method, top_n=top_n)

        fig, ax = plt.subplots(figsize=(14, 12))

        clusters = self.clusters_dbscan if method == 'dbscan' else self.clusters_kmeans

        # Toutes les photos en gris clair
        ax.scatter(self.df_clean['longitude'], self.df_clean['latitude'],
                  s=5, alpha=0.2, c='lightgray', label='Toutes les photos')

        # Top POI en couleur
        colors = plt.cm.tab10(np.linspace(0, 1, top_n))

        for idx, (i, row) in enumerate(self.poi_stats.head(top_n).iterrows()):
            cluster_id = row['cluster_id']
            cluster_data = self.df_clean[self.df_clean[f'cluster_{method}'] == cluster_id]

            # Photos du cluster
            ax.scatter(cluster_data['longitude'], cluster_data['latitude'],
                      s=30, alpha=0.7, c=[colors[idx]],
                      label=f"POI {cluster_id} ({row['n_photos']} photos)")

            # Centre du POI
            ax.scatter(row['center_lon'], row['center_lat'],
                      s=200, alpha=0.9, c=[colors[idx]],
                      marker='*', edgecolors='black', linewidth=2)

            # Annotation
            ax.annotate(f"POI {cluster_id}",
                       (row['center_lon'], row['center_lat']),
                       fontsize=9, xytext=(5, 5),
                       textcoords='offset points',
                       bbox=dict(boxstyle='round,pad=0.3', facecolor=colors[idx], alpha=0.7))

        ax.set_xlabel('Longitude', fontsize=12)
        ax.set_ylabel('Latitude', fontsize=12)
        ax.set_title(f'Carte des {top_n} POI principaux ({method.upper()})',
                    fontsize=14, pad=20)
        ax.legend(loc='best', fontsize=8, ncol=2)
        ax.grid(alpha=0.3)

        plt.tight_layout()
        plt.savefig(f'poi_map_{method}.png', dpi=300, bbox_inches='tight')
        print(f"Carte des POI sauvegardée: poi_map_{method}.png")

    def full_analysis(self):
        """Effectue l'analyse complète"""
        print("="*80)
        print("ANALYSE COMPLÈTE - DÉTECTION ET CARACTÉRISATION DE POI")
        print("="*80)

        # 1. Exploration
        self.explore_data()

        # 2. Prétraitement
        self.preprocess_data()

        # 3. Visualisation initiale
        self.plot_spatial_distribution()

        # 4. Détermination eps
        suggested_eps = self.determine_optimal_eps(k=5)

        # 5. Clustering DBSCAN
        self.apply_dbscan(eps=int(suggested_eps), min_samples=10)

        # 6. Clustering K-means
        n_clusters_kmeans = len(set(self.clusters_dbscan)) - (1 if -1 in self.clusters_dbscan else 0)
        self.apply_kmeans(n_clusters=max(n_clusters_kmeans, 5))

        # 7. Comparaison
        self.compare_methods()

        # 8. Caractérisation DBSCAN
        self.characterize_poi(method='dbscan', top_n=10)
        self.plot_poi_map(method='dbscan', top_n=10)

        # 9. Caractérisation K-means
        self.characterize_poi(method='kmeans', top_n=10)
        self.plot_poi_map(method='kmeans', top_n=10)

        print("\n" + "="*80)
        print("ANALYSE TERMINÉE")
        print("Tous les graphiques et fichiers ont été sauvegardés")
        print("="*80)


def main():
    """Fonction principale"""

    # Initialisation
    analysis = POIDetection()

    # Chargement des données
    # Si vous avez un fichier CSV Flickr:
    # analysis.load_data('flickr_rennes_2019.csv')

    # Sinon, données d'exemple
    analysis.create_sample_data(n_photos=1000)

    # Analyse complète
    analysis.full_analysis()


if __name__ == "__main__":
    main()
