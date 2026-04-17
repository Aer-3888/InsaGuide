"""
TP 2: Classification Hiérarchique (CAH-MIXTE) après ACP
Auteur: ADFD - INSA Rennes 3INFO
Description: Classification des villes françaises par méthode hiérarchique sur composantes principales
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster
from scipy.spatial.distance import cdist
from sklearn.metrics import silhouette_score, davies_bouldin_score
import seaborn as sns

plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")


class HierarchicalClusteringAnalysis:
    """Classe pour l'analyse de classification hiérarchique après ACP"""

    def __init__(self, data_file=None):
        """
        Initialise l'analyse

        Args:
            data_file: Chemin vers le fichier CSV contenant les données
        """
        self.data = None
        self.cities = None
        self.months = None
        self.pca = None
        self.scaled_data = None
        self.principal_components = None
        self.linkage_matrix = None
        self.clusters = None

        if data_file:
            self.load_data(data_file)

    def load_data(self, file_path):
        """Charge les données depuis un fichier CSV"""
        self.data = pd.read_csv(file_path, index_col=0)
        self.cities = self.data.index.tolist()
        self.months = self.data.columns.tolist()
        print(f"Données chargées: {len(self.cities)} villes, {len(self.months)} mois")

    def create_sample_data(self):
        """Crée un jeu de données d'exemple"""
        cities = ['Bordeaux', 'Brest', 'Clermont-Ferrand', 'Grenoble', 'Lille',
                  'Lyon', 'Marseille', 'Montpellier', 'Nantes', 'Nice',
                  'Paris', 'Rennes', 'Strasbourg', 'Toulouse', 'Vichy']

        # Températures mensuelles moyennes (approximatives)
        data = {
            'Janvier': [6.2, 7.2, 3.7, 3.1, 4.0, 4.2, 7.1, 7.3, 5.9, 8.7, 4.7, 6.0, 1.9, 6.1, 3.8],
            'Février': [7.5, 7.6, 5.1, 4.8, 4.8, 5.9, 8.3, 8.5, 6.8, 9.3, 5.8, 6.7, 3.7, 7.6, 5.2],
            'Mars': [10.2, 9.4, 8.0, 8.3, 7.8, 9.5, 11.4, 11.3, 9.2, 11.5, 9.1, 9.0, 7.8, 10.4, 8.3],
            'Avril': [12.6, 10.8, 10.6, 11.2, 10.1, 12.6, 14.1, 13.8, 11.4, 13.7, 12.0, 10.9, 11.4, 13.0, 10.9],
            'Mai': [16.3, 13.9, 14.6, 15.4, 13.9, 16.8, 18.0, 17.4, 14.7, 17.2, 15.8, 14.2, 15.8, 16.8, 14.9],
            'Juin': [19.7, 16.6, 18.1, 19.3, 16.8, 20.8, 22.2, 21.3, 17.8, 20.9, 19.0, 17.2, 19.4, 20.5, 18.4],
            'Juillet': [22.0, 18.4, 20.5, 21.8, 18.8, 23.5, 24.7, 24.0, 19.7, 23.5, 21.4, 19.2, 21.6, 23.0, 20.8],
            'Août': [21.7, 18.3, 20.2, 21.4, 18.9, 23.0, 24.6, 23.7, 19.5, 23.6, 21.2, 19.1, 21.1, 22.7, 20.5],
            'Septembre': [18.7, 16.3, 16.8, 17.5, 16.2, 19.0, 21.1, 20.5, 17.1, 20.4, 17.9, 16.9, 17.4, 19.3, 17.1],
            'Octobre': [14.5, 13.3, 12.3, 12.9, 12.5, 14.1, 16.6, 16.4, 13.6, 16.5, 13.8, 13.4, 12.3, 15.0, 12.6],
            'Novembre': [9.6, 10.0, 7.0, 6.9, 7.6, 8.2, 11.4, 11.2, 9.3, 12.0, 8.3, 9.1, 6.3, 9.8, 7.3],
            'Décembre': [6.9, 7.9, 4.5, 3.9, 5.1, 5.1, 8.3, 8.5, 6.8, 9.5, 5.6, 6.8, 3.1, 7.1, 4.8],
        }

        self.data = pd.DataFrame(data, index=cities)
        self.cities = cities
        self.months = list(data.keys())
        print("Données d'exemple créées")

    def perform_pca(self, n_components=2):
        """
        Effectue l'ACP sur les données

        Args:
            n_components: Nombre de composantes à calculer
        """
        print(f"\n=== ANALYSE EN COMPOSANTES PRINCIPALES ===")

        # Standardisation
        scaler = StandardScaler()
        self.scaled_data = scaler.fit_transform(self.data)

        # ACP
        self.pca = PCA(n_components=n_components)
        self.principal_components = self.pca.fit_transform(self.scaled_data)

        # Résultats
        print(f"\nVariance expliquée:")
        for i, var in enumerate(self.pca.explained_variance_ratio_, 1):
            print(f"  PC{i}: {var*100:.2f}%")

        cumsum = np.sum(self.pca.explained_variance_ratio_)
        print(f"\nVariance cumulée ({n_components} composantes): {cumsum*100:.2f}%")

        return self.principal_components

    def hierarchical_clustering_comparison(self):
        """Compare les classifications avec différentes méthodes de liaison"""
        if self.principal_components is None:
            print("Erreur: Effectuez d'abord l'ACP")
            return

        print("\n=== COMPARAISON DES MÉTHODES DE LIAISON ===")

        methods = ['ward', 'complete', 'average', 'single']
        n_clusters = 3

        fig, axes = plt.subplots(2, 2, figsize=(16, 12))
        axes = axes.ravel()

        for idx, method in enumerate(methods):
            # Calcul de la liaison
            linkage_matrix = linkage(self.principal_components[:, :2],
                                    method=method)

            # Dendrogramme
            axes[idx].set_title(f'Méthode: {method.upper()}', fontsize=12, pad=10)
            dendrogram(linkage_matrix, labels=self.cities, ax=axes[idx],
                      leaf_font_size=9)
            axes[idx].set_xlabel('Villes', fontsize=10)
            axes[idx].set_ylabel('Distance', fontsize=10)
            axes[idx].tick_params(axis='x', rotation=45)

        plt.tight_layout()
        plt.savefig('comparison_linkage_methods.png', dpi=300, bbox_inches='tight')
        print("Comparaison des méthodes sauvegardée: comparison_linkage_methods.png")

    def hierarchical_clustering(self, n_clusters=3, method='ward',
                               use_n_components=2):
        """
        Effectue la classification hiérarchique

        Args:
            n_clusters: Nombre de clusters souhaité
            method: Méthode de liaison
            use_n_components: Nombre de composantes principales à utiliser
        """
        if self.principal_components is None:
            print("Erreur: Effectuez d'abord l'ACP")
            return None

        print(f"\n=== CLASSIFICATION HIÉRARCHIQUE ===")
        print(f"Méthode: {method}")
        print(f"Nombre de clusters: {n_clusters}")
        print(f"Composantes utilisées: {use_n_components}")

        # Sélection des composantes
        data_for_clustering = self.principal_components[:, :use_n_components]

        # Liaison hiérarchique
        self.linkage_matrix = linkage(data_for_clustering, method=method)

        # Formation des clusters
        self.clusters = fcluster(self.linkage_matrix, n_clusters,
                                criterion='maxclust')

        # Affichage des résultats
        print("\nComposition des clusters:")
        for i in range(1, n_clusters + 1):
            cities_in_cluster = [self.cities[j] for j in range(len(self.cities))
                               if self.clusters[j] == i]
            print(f"\n  Cluster {i} ({len(cities_in_cluster)} villes):")
            print(f"    {', '.join(cities_in_cluster)}")

        # Métriques d'évaluation
        self.compute_metrics()

        return self.clusters

    def compute_metrics(self):
        """Calcule les métriques d'évaluation du clustering"""
        if self.clusters is None:
            return

        # Silhouette score
        silhouette = silhouette_score(self.principal_components[:, :2],
                                      self.clusters)

        # Davies-Bouldin index
        davies_bouldin = davies_bouldin_score(self.principal_components[:, :2],
                                             self.clusters)

        # Inertie intra-cluster
        inertia_intra = 0
        n_clusters = len(np.unique(self.clusters))

        for i in range(1, n_clusters + 1):
            cluster_points = self.principal_components[self.clusters == i, :2]
            center = cluster_points.mean(axis=0)
            inertia_intra += np.sum((cluster_points - center) ** 2)

        print("\n=== MÉTRIQUES D'ÉVALUATION ===")
        print(f"Silhouette Score: {silhouette:.4f}")
        print(f"  Interprétation: [-1, 1], plus proche de 1 = meilleur")
        print(f"Davies-Bouldin Index: {davies_bouldin:.4f}")
        print(f"  Interprétation: Plus faible = meilleur")
        print(f"Inertie intra-cluster: {inertia_intra:.4f}")
        print(f"  Interprétation: Plus faible = clusters plus compacts")

    def find_paragons(self):
        """Identifie les paragons (individus les plus représentatifs) de chaque cluster"""
        if self.clusters is None:
            print("Erreur: Effectuez d'abord la classification")
            return

        print("\n=== IDENTIFICATION DES PARAGONS ===")

        n_clusters = len(np.unique(self.clusters))
        paragons = {}

        for i in range(1, n_clusters + 1):
            # Points du cluster
            mask = self.clusters == i
            cluster_points = self.principal_components[mask, :2]
            cluster_cities = [self.cities[j] for j in range(len(self.cities))
                            if self.clusters[j] == i]

            # Centre de gravité (barycentre)
            centroid = cluster_points.mean(axis=0)

            # Distance de chaque point au centre
            distances = cdist(cluster_points, [centroid], metric='euclidean').flatten()

            # Paragon = point le plus proche du centre
            paragon_idx = np.argmin(distances)
            paragon = cluster_cities[paragon_idx]
            paragon_distance = distances[paragon_idx]

            paragons[i] = {
                'city': paragon,
                'distance': paragon_distance,
                'centroid': centroid
            }

            print(f"\nCluster {i}:")
            print(f"  Paragon: {paragon}")
            print(f"  Distance au centre: {paragon_distance:.4f}")
            print(f"  Centre de gravité: PC1={centroid[0]:.4f}, PC2={centroid[1]:.4f}")

        return paragons

    def plot_dendrogram(self, method='ward'):
        """
        Visualise le dendrogramme

        Args:
            method: Méthode de liaison
        """
        if self.linkage_matrix is None:
            # Calculer si pas encore fait
            self.hierarchical_clustering(method=method)

        plt.figure(figsize=(14, 8))

        # Dendrogramme
        dendrogram(self.linkage_matrix, labels=self.cities,
                  leaf_font_size=11, leaf_rotation=45)

        plt.title(f'Dendrogramme - Classification Hiérarchique ({method})',
                 fontsize=14, pad=20)
        plt.xlabel('Villes', fontsize=12)
        plt.ylabel('Distance', fontsize=12)
        plt.tight_layout()
        plt.savefig(f'dendrogram_{method}.png', dpi=300, bbox_inches='tight')
        print(f"Dendrogramme sauvegardé: dendrogram_{method}.png")

    def plot_clusters_on_pca(self, n_clusters=3):
        """Visualise les clusters sur le plan factoriel"""
        if self.clusters is None or self.principal_components is None:
            print("Erreur: Effectuez d'abord l'ACP et la classification")
            return

        plt.figure(figsize=(12, 10))

        # Couleurs pour les clusters
        colors = plt.cm.tab10(np.linspace(0, 1, n_clusters))

        # Centres des clusters
        centroids = []

        for i in range(1, n_clusters + 1):
            mask = self.clusters == i
            x = self.principal_components[mask, 0]
            y = self.principal_components[mask, 1]

            # Points
            plt.scatter(x, y, s=150, alpha=0.6, color=colors[i-1],
                       label=f'Cluster {i}', edgecolors='black', linewidth=1)

            # Centre du cluster
            centroid = [x.mean(), y.mean()]
            centroids.append(centroid)
            plt.scatter(*centroid, s=300, alpha=0.9, color=colors[i-1],
                       marker='*', edgecolors='black', linewidth=2)

            # Annotations
            for j in range(len(self.cities)):
                if self.clusters[j] == i:
                    plt.annotate(self.cities[j],
                               (self.principal_components[j, 0],
                                self.principal_components[j, 1]),
                               fontsize=9, xytext=(5, 5),
                               textcoords='offset points')

        # Axes
        plt.axhline(y=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)
        plt.axvline(x=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)

        # Labels
        var1 = self.pca.explained_variance_ratio_[0] * 100
        var2 = self.pca.explained_variance_ratio_[1] * 100
        plt.xlabel(f'Composante 1 ({var1:.2f}%)', fontsize=12)
        plt.ylabel(f'Composante 2 ({var2:.2f}%)', fontsize=12)
        plt.title(f'Classification en {n_clusters} clusters sur le plan factoriel',
                 fontsize=14, pad=20)
        plt.legend(loc='best', fontsize=10)
        plt.grid(alpha=0.3)

        plt.tight_layout()
        plt.savefig(f'clusters_pca_{n_clusters}.png', dpi=300, bbox_inches='tight')
        print(f"Clusters sur plan factoriel sauvegardés: clusters_pca_{n_clusters}.png")

    def plot_elbow_curve(self, max_clusters=10):
        """
        Trace la courbe du coude pour déterminer le nombre optimal de clusters

        Args:
            max_clusters: Nombre maximum de clusters à tester
        """
        if self.principal_components is None:
            print("Erreur: Effectuez d'abord l'ACP")
            return

        print("\n=== ANALYSE DU NOMBRE OPTIMAL DE CLUSTERS ===")

        inertias = []
        silhouettes = []
        davies_bouldins = []
        k_range = range(2, max_clusters + 1)

        for k in k_range:
            # Classification
            linkage_matrix = linkage(self.principal_components[:, :2],
                                    method='ward')
            clusters = fcluster(linkage_matrix, k, criterion='maxclust')

            # Inertie intra-cluster
            inertia = 0
            for i in range(1, k + 1):
                cluster_points = self.principal_components[clusters == i, :2]
                if len(cluster_points) > 0:
                    center = cluster_points.mean(axis=0)
                    inertia += np.sum((cluster_points - center) ** 2)
            inertias.append(inertia)

            # Métriques
            silhouette = silhouette_score(self.principal_components[:, :2],
                                         clusters)
            silhouettes.append(silhouette)

            davies_bouldin = davies_bouldin_score(self.principal_components[:, :2],
                                                 clusters)
            davies_bouldins.append(davies_bouldin)

            print(f"k={k}: Inertie={inertia:.2f}, Silhouette={silhouette:.4f}, "
                  f"Davies-Bouldin={davies_bouldin:.4f}")

        # Visualisation
        fig, axes = plt.subplots(1, 3, figsize=(16, 5))

        # Courbe du coude (inertie)
        axes[0].plot(k_range, inertias, 'o-', linewidth=2, markersize=8)
        axes[0].set_xlabel('Nombre de clusters', fontsize=12)
        axes[0].set_ylabel('Inertie intra-cluster', fontsize=12)
        axes[0].set_title('Méthode du coude', fontsize=14)
        axes[0].grid(alpha=0.3)

        # Silhouette score
        axes[1].plot(k_range, silhouettes, 'o-', linewidth=2, markersize=8,
                    color='green')
        axes[1].set_xlabel('Nombre de clusters', fontsize=12)
        axes[1].set_ylabel('Silhouette Score', fontsize=12)
        axes[1].set_title('Silhouette Score (plus élevé = meilleur)', fontsize=14)
        axes[1].grid(alpha=0.3)

        # Davies-Bouldin index
        axes[2].plot(k_range, davies_bouldins, 'o-', linewidth=2, markersize=8,
                    color='red')
        axes[2].set_xlabel('Nombre de clusters', fontsize=12)
        axes[2].set_ylabel('Davies-Bouldin Index', fontsize=12)
        axes[2].set_title('Davies-Bouldin Index (plus faible = meilleur)',
                         fontsize=14)
        axes[2].grid(alpha=0.3)

        plt.tight_layout()
        plt.savefig('elbow_curve.png', dpi=300, bbox_inches='tight')
        print("\nCourbes d'évaluation sauvegardées: elbow_curve.png")

        # Recommandation
        optimal_k = k_range[np.argmax(silhouettes)]
        print(f"\nNombre optimal de clusters (selon Silhouette): {optimal_k}")

    def cluster_profiling(self):
        """Analyse détaillée de chaque cluster"""
        if self.clusters is None:
            print("Erreur: Effectuez d'abord la classification")
            return

        print("\n=== PROFILING DES CLUSTERS ===")

        n_clusters = len(np.unique(self.clusters))

        for i in range(1, n_clusters + 1):
            print(f"\n{'='*60}")
            print(f"CLUSTER {i}")
            print('='*60)

            # Villes du cluster
            mask = self.clusters == i
            cities_in_cluster = [self.cities[j] for j in range(len(self.cities))
                               if self.clusters[j] == i]

            print(f"\nVilles ({len(cities_in_cluster)}): {', '.join(cities_in_cluster)}")

            # Statistiques des températures
            cluster_data = self.data.loc[cities_in_cluster]

            print("\nTempératures moyennes par mois:")
            print(cluster_data.mean().round(2))

            print("\nÉcart-type par mois:")
            print(cluster_data.std().round(2))

            print("\nTempérature annuelle moyenne du cluster:")
            print(f"  {cluster_data.values.mean():.2f}°C")

            print("\nAmplitude thermique moyenne (été - hiver):")
            summer = cluster_data[['Juin', 'Juillet', 'Août']].mean(axis=1).mean()
            winter = cluster_data[['Décembre', 'Janvier', 'Février']].mean(axis=1).mean()
            print(f"  {summer - winter:.2f}°C")

    def full_analysis(self):
        """Effectue l'analyse complète"""
        print("="*70)
        print("ANALYSE COMPLÈTE - CLASSIFICATION HIÉRARCHIQUE APRÈS ACP")
        print("="*70)

        # 1. ACP
        self.perform_pca(n_components=12)
        self.perform_pca(n_components=2)

        # 2. Comparaison des méthodes
        self.hierarchical_clustering_comparison()

        # 3. Courbe du coude
        self.plot_elbow_curve(max_clusters=8)

        # 4. Classifications avec différents nombres de clusters
        for n_clusters in [2, 3, 4]:
            print(f"\n{'#'*70}")
            print(f"# CLASSIFICATION EN {n_clusters} CLUSTERS")
            print('#'*70)

            self.hierarchical_clustering(n_clusters=n_clusters, method='ward',
                                        use_n_components=2)
            self.plot_dendrogram(method='ward')
            self.plot_clusters_on_pca(n_clusters=n_clusters)
            self.find_paragons()
            self.cluster_profiling()

        print("\n" + "="*70)
        print("ANALYSE TERMINÉE")
        print("Tous les graphiques ont été sauvegardés")
        print("="*70)


def main():
    """Fonction principale"""

    # Initialisation
    analysis = HierarchicalClusteringAnalysis()

    # Chargement des données
    # Si vous avez un fichier CSV:
    # analysis.load_data('temperatures_villes.csv')

    # Sinon, données d'exemple
    analysis.create_sample_data()

    # Analyse complète
    analysis.full_analysis()


if __name__ == "__main__":
    main()
