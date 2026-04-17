"""
TP 1: Analyse en Composantes Principales (PCA) - Températures des villes françaises
Auteur: ADFD - INSA Rennes 3INFO
Description: Analyse ACP des températures mensuelles de 17 villes françaises
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster
import seaborn as sns

# Configuration pour de meilleurs graphiques
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")


class CityTemperatureAnalysis:
    """Classe pour l'analyse ACP des températures des villes françaises"""

    def __init__(self, data_file=None):
        """
        Initialise l'analyse avec les données de température

        Args:
            data_file: Chemin vers le fichier CSV contenant les données
        """
        self.data = None
        self.cities = None
        self.months = None
        self.pca = None
        self.scaled_data = None
        self.principal_components = None

        if data_file:
            self.load_data(data_file)

    def load_data(self, file_path):
        """
        Charge les données depuis un fichier CSV

        Args:
            file_path: Chemin vers le fichier CSV
        """
        self.data = pd.read_csv(file_path, index_col=0)
        self.cities = self.data.index.tolist()
        self.months = self.data.columns.tolist()
        print(f"Données chargées: {len(self.cities)} villes, {len(self.months)} mois")

    def create_sample_data(self):
        """Crée un jeu de données d'exemple basé sur le TP"""
        cities = ['Bordeaux', 'Brest', 'Clermont-Ferrand', 'Grenoble', 'Lille',
                  'Lyon', 'Marseille', 'Montpellier', 'Nantes', 'Nice',
                  'Paris', 'Rennes', 'Strasbourg', 'Toulouse', 'Vichy']

        months = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
                  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']

        # Données approximatives basées sur les résultats du TP
        data = {
            'Janvier': [3.97, 4.85, 3.97, 3.97, 3.97, 3.97, 4.83, 3.97, 3.97, 4.83, 3.97, 3.97, 3.97, 3.97, 3.97],
            'Février': [4.85, 4.83, 4.85, 4.85, 4.85, 4.85, 4.83, 4.85, 4.85, 4.83, 4.85, 4.85, 4.85, 4.85, 4.85],
            'Mars': [10.98, 12.32, 10.98, 10.98, 10.98, 10.98, 10.98, 10.98, 10.98, 10.98, 10.98, 10.98, 10.98, 10.98, 10.98],
            'Avril': [16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99, 16.99],
            'Mai': [11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81, 11.81],
            'Juin': [17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83, 17.83],
            'Juillet': [19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83, 19.83],
            'Août': [2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58, 2.58],
            'Septembre': [15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91, 15.91],
            'Octobre': [12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32, 12.32],
            'Novembre': [7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93, 7.93],
            'Décembre': [4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85, 4.85],
        }

        self.data = pd.DataFrame(data, index=cities)
        self.cities = cities
        self.months = months
        print("Données d'exemple créées")

    def descriptive_statistics(self):
        """Affiche les statistiques descriptives des données"""
        print("\n=== STATISTIQUES DESCRIPTIVES ===")
        print("\nMoyenne par mois:")
        print(self.data.mean())
        print("\nÉcart-type par mois:")
        print(self.data.std())
        print("\nMoyenne par ville:")
        print(self.data.mean(axis=1).sort_values(ascending=False))

    def correlation_analysis(self):
        """Analyse et visualise la matrice de corrélation"""
        print("\n=== ANALYSE DE CORRÉLATION ===")
        correlation_matrix = self.data.corr()
        print("\nMatrice de corrélation:")
        print(correlation_matrix)

        # Visualisation de la matrice de corrélation
        plt.figure(figsize=(12, 10))
        sns.heatmap(correlation_matrix, annot=True, fmt='.2f',
                   cmap='coolwarm', center=0, vmin=-1, vmax=1,
                   square=True, linewidths=1)
        plt.title('Matrice de corrélation entre les mois', fontsize=14, pad=20)
        plt.tight_layout()
        plt.savefig('correlation_matrix.png', dpi=300, bbox_inches='tight')
        print("Matrice de corrélation sauvegardée: correlation_matrix.png")

    def perform_pca(self, n_components=2):
        """
        Effectue l'ACP sur les données

        Args:
            n_components: Nombre de composantes principales à calculer
        """
        print(f"\n=== ANALYSE EN COMPOSANTES PRINCIPALES (ACP) ===")

        # Standardisation des données (ACP normée)
        scaler = StandardScaler()
        self.scaled_data = scaler.fit_transform(self.data)

        # Application de l'ACP
        self.pca = PCA(n_components=n_components)
        self.principal_components = self.pca.fit_transform(self.scaled_data)

        # Affichage des résultats
        print(f"\nVariance expliquée par chaque composante:")
        for i, var in enumerate(self.pca.explained_variance_ratio_, 1):
            print(f"  Composante {i}: {var*100:.2f}%")

        print(f"\nVariance cumulée:")
        cumsum = np.cumsum(self.pca.explained_variance_ratio_)
        for i, var in enumerate(cumsum, 1):
            print(f"  {i} composante(s): {var*100:.2f}%")

        return self.principal_components

    def plot_scree_diagram(self):
        """Affiche le diagramme des valeurs propres (scree plot)"""
        if self.pca is None:
            print("Erreur: Effectuez d'abord l'ACP avec perform_pca()")
            return

        variance_ratio = self.pca.explained_variance_ratio_ * 100
        cumulative_variance = np.cumsum(variance_ratio)

        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

        # Diagramme en barres
        components = range(1, len(variance_ratio) + 1)
        ax1.bar(components, variance_ratio, alpha=0.7, color='steelblue')
        ax1.set_xlabel('Composante principale', fontsize=12)
        ax1.set_ylabel('Pourcentage de variance expliquée (%)', fontsize=12)
        ax1.set_title('Variance expliquée par composante', fontsize=14)
        ax1.grid(axis='y', alpha=0.3)

        # Variance cumulée
        ax2.plot(components, cumulative_variance, 'o-', linewidth=2, markersize=8)
        ax2.axhline(y=80, color='r', linestyle='--', label='80% threshold')
        ax2.set_xlabel('Nombre de composantes', fontsize=12)
        ax2.set_ylabel('Variance cumulée (%)', fontsize=12)
        ax2.set_title('Variance cumulée', fontsize=14)
        ax2.legend()
        ax2.grid(alpha=0.3)

        plt.tight_layout()
        plt.savefig('scree_plot.png', dpi=300, bbox_inches='tight')
        print("Diagramme des valeurs propres sauvegardé: scree_plot.png")

    def plot_individuals(self, ax1=0, ax2=1):
        """
        Visualise le plan factoriel des individus (villes)

        Args:
            ax1: Index de la première composante (0 pour PC1)
            ax2: Index de la deuxième composante (1 pour PC2)
        """
        if self.principal_components is None:
            print("Erreur: Effectuez d'abord l'ACP avec perform_pca()")
            return

        plt.figure(figsize=(12, 10))

        # Projection des villes
        x = self.principal_components[:, ax1]
        y = self.principal_components[:, ax2]

        plt.scatter(x, y, s=100, alpha=0.6, color='steelblue')

        # Annotation des villes
        for i, city in enumerate(self.cities):
            plt.annotate(city, (x[i], y[i]), fontsize=10,
                        xytext=(5, 5), textcoords='offset points')

        # Axes
        plt.axhline(y=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)
        plt.axvline(x=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)

        # Labels
        var1 = self.pca.explained_variance_ratio_[ax1] * 100
        var2 = self.pca.explained_variance_ratio_[ax2] * 100
        plt.xlabel(f'Axe {ax1+1} ({var1:.2f}%)', fontsize=12)
        plt.ylabel(f'Axe {ax2+1} ({var2:.2f}%)', fontsize=12)
        plt.title('Plan factoriel des individus (villes)', fontsize=14, pad=20)
        plt.grid(alpha=0.3)

        plt.tight_layout()
        plt.savefig('pca_individuals.png', dpi=300, bbox_inches='tight')
        print("Plan factoriel des individus sauvegardé: pca_individuals.png")

    def plot_variables(self, ax1=0, ax2=1):
        """
        Visualise le cercle des corrélations (plan factoriel des variables)

        Args:
            ax1: Index de la première composante (0 pour PC1)
            ax2: Index de la deuxième composante (1 pour PC2)
        """
        if self.pca is None:
            print("Erreur: Effectuez d'abord l'ACP avec perform_pca()")
            return

        plt.figure(figsize=(10, 10))

        # Calcul des coordonnées des variables sur les axes factoriels
        # Corrélation entre variables et composantes principales
        loadings = self.pca.components_.T * np.sqrt(self.pca.explained_variance_)

        # Cercle de corrélation
        circle = plt.Circle((0, 0), 1, color='gray', fill=False, linewidth=2)
        plt.gca().add_patch(circle)

        # Projection des variables (mois)
        for i, month in enumerate(self.months):
            plt.arrow(0, 0, loadings[i, ax1], loadings[i, ax2],
                     head_width=0.05, head_length=0.05, fc='red', ec='red', alpha=0.7)
            plt.text(loadings[i, ax1] * 1.15, loadings[i, ax2] * 1.15,
                    month, fontsize=10, ha='center', va='center')

        # Axes
        plt.axhline(y=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)
        plt.axvline(x=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)

        # Labels
        var1 = self.pca.explained_variance_ratio_[ax1] * 100
        var2 = self.pca.explained_variance_ratio_[ax2] * 100
        plt.xlabel(f'Axe {ax1+1} ({var1:.2f}%)', fontsize=12)
        plt.ylabel(f'Axe {ax2+1} ({var2:.2f}%)', fontsize=12)
        plt.title('Cercle des corrélations (variables)', fontsize=14, pad=20)

        # Limites du graphique
        plt.xlim(-1.1, 1.1)
        plt.ylim(-1.1, 1.1)
        plt.grid(alpha=0.3)
        plt.gca().set_aspect('equal')

        plt.tight_layout()
        plt.savefig('pca_variables.png', dpi=300, bbox_inches='tight')
        print("Cercle des corrélations sauvegardé: pca_variables.png")

    def plot_biplot(self, ax1=0, ax2=1, scale_factor=3):
        """
        Crée un biplot combinant individus et variables

        Args:
            ax1: Index de la première composante
            ax2: Index de la deuxième composante
            scale_factor: Facteur d'échelle pour les flèches des variables
        """
        if self.principal_components is None or self.pca is None:
            print("Erreur: Effectuez d'abord l'ACP avec perform_pca()")
            return

        fig, ax = plt.subplots(figsize=(14, 12))

        # Individus (villes)
        x_ind = self.principal_components[:, ax1]
        y_ind = self.principal_components[:, ax2]
        ax.scatter(x_ind, y_ind, s=100, alpha=0.6, color='steelblue', label='Villes')

        for i, city in enumerate(self.cities):
            ax.annotate(city, (x_ind[i], y_ind[i]), fontsize=9,
                       xytext=(5, 5), textcoords='offset points')

        # Variables (mois)
        loadings = self.pca.components_.T * np.sqrt(self.pca.explained_variance_)
        x_var = loadings[:, ax1] * scale_factor
        y_var = loadings[:, ax2] * scale_factor

        for i, month in enumerate(self.months):
            ax.arrow(0, 0, x_var[i], y_var[i],
                    head_width=0.2, head_length=0.2, fc='red', ec='red', alpha=0.7)
            ax.text(x_var[i] * 1.15, y_var[i] * 1.15, month,
                   fontsize=9, color='red', ha='center', va='center')

        # Axes
        ax.axhline(y=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)
        ax.axvline(x=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)

        # Labels
        var1 = self.pca.explained_variance_ratio_[ax1] * 100
        var2 = self.pca.explained_variance_ratio_[ax2] * 100
        ax.set_xlabel(f'Composante {ax1+1} ({var1:.2f}%)', fontsize=12)
        ax.set_ylabel(f'Composante {ax2+1} ({var2:.2f}%)', fontsize=12)
        ax.set_title('Biplot - Individus et Variables', fontsize=14, pad=20)
        ax.legend()
        ax.grid(alpha=0.3)

        plt.tight_layout()
        plt.savefig('pca_biplot.png', dpi=300, bbox_inches='tight')
        print("Biplot sauvegardé: pca_biplot.png")

    def hierarchical_clustering(self, n_clusters=3, method='ward'):
        """
        Effectue une classification hiérarchique sur les composantes principales

        Args:
            n_clusters: Nombre de clusters à former
            method: Méthode de liaison ('ward', 'complete', 'average', 'single')
        """
        if self.principal_components is None:
            print("Erreur: Effectuez d'abord l'ACP avec perform_pca()")
            return None

        print(f"\n=== CLASSIFICATION HIÉRARCHIQUE (CAH) ===")
        print(f"Méthode: {method}, Nombre de clusters: {n_clusters}")

        # Utilise uniquement les 2 premières composantes principales
        data_for_clustering = self.principal_components[:, :2]

        # Calcul de la liaison hiérarchique
        linkage_matrix = linkage(data_for_clustering, method=method)

        # Formation des clusters
        clusters = fcluster(linkage_matrix, n_clusters, criterion='maxclust')

        # Affichage des résultats
        print("\nRésultats de la classification:")
        for i in range(1, n_clusters + 1):
            cities_in_cluster = [self.cities[j] for j in range(len(self.cities))
                               if clusters[j] == i]
            print(f"  Cluster {i}: {', '.join(cities_in_cluster)}")

        # Visualisation du dendrogramme
        plt.figure(figsize=(14, 8))
        dendrogram(linkage_matrix, labels=self.cities, leaf_font_size=10)
        plt.title(f'Dendrogramme - Classification Hiérarchique ({method})',
                 fontsize=14, pad=20)
        plt.xlabel('Villes', fontsize=12)
        plt.ylabel('Distance', fontsize=12)
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()
        plt.savefig('dendrogram.png', dpi=300, bbox_inches='tight')
        print("Dendrogramme sauvegardé: dendrogram.png")

        # Visualisation des clusters sur le plan factoriel
        self.plot_clusters(clusters, n_clusters)

        return clusters

    def plot_clusters(self, clusters, n_clusters):
        """
        Visualise les clusters sur le plan factoriel

        Args:
            clusters: Array des labels de clusters
            n_clusters: Nombre de clusters
        """
        plt.figure(figsize=(12, 10))

        colors = plt.cm.tab10(np.linspace(0, 1, n_clusters))

        for i in range(1, n_clusters + 1):
            mask = clusters == i
            x = self.principal_components[mask, 0]
            y = self.principal_components[mask, 1]
            plt.scatter(x, y, s=150, alpha=0.6, color=colors[i-1],
                       label=f'Cluster {i}')

            # Annotation
            cities_in_cluster = [self.cities[j] for j in range(len(self.cities))
                               if clusters[j] == i]
            for j, city in enumerate(cities_in_cluster):
                idx = self.cities.index(city)
                plt.annotate(city,
                           (self.principal_components[idx, 0],
                            self.principal_components[idx, 1]),
                           fontsize=9, xytext=(5, 5), textcoords='offset points')

        # Axes
        plt.axhline(y=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)
        plt.axvline(x=0, color='k', linewidth=0.5, linestyle='--', alpha=0.3)

        # Labels
        var1 = self.pca.explained_variance_ratio_[0] * 100
        var2 = self.pca.explained_variance_ratio_[1] * 100
        plt.xlabel(f'Composante 1 ({var1:.2f}%)', fontsize=12)
        plt.ylabel(f'Composante 2 ({var2:.2f}%)', fontsize=12)
        plt.title(f'Classification en {n_clusters} clusters', fontsize=14, pad=20)
        plt.legend()
        plt.grid(alpha=0.3)

        plt.tight_layout()
        plt.savefig(f'clusters_{n_clusters}.png', dpi=300, bbox_inches='tight')
        print(f"Visualisation des clusters sauvegardée: clusters_{n_clusters}.png")

    def full_analysis(self):
        """Effectue l'analyse complète"""
        print("="*60)
        print("ANALYSE COMPLÈTE DES TEMPÉRATURES DES VILLES FRANÇAISES")
        print("="*60)

        # 1. Statistiques descriptives
        self.descriptive_statistics()

        # 2. Analyse de corrélation
        self.correlation_analysis()

        # 3. ACP
        self.perform_pca(n_components=12)
        self.plot_scree_diagram()
        self.plot_individuals()
        self.plot_variables()
        self.plot_biplot()

        # 4. Classification hiérarchique
        self.hierarchical_clustering(n_clusters=2)
        self.hierarchical_clustering(n_clusters=3)

        print("\n" + "="*60)
        print("ANALYSE TERMINÉE")
        print("Tous les graphiques ont été sauvegardés dans le répertoire courant")
        print("="*60)


def main():
    """Fonction principale pour exécuter l'analyse"""

    # Initialisation
    analysis = CityTemperatureAnalysis()

    # Chargement des données
    # Si vous avez un fichier CSV, décommentez la ligne suivante:
    # analysis.load_data('temperatures_villes.csv')

    # Sinon, utiliser les données d'exemple
    analysis.create_sample_data()

    # Analyse complète
    analysis.full_analysis()


if __name__ == "__main__":
    main()
