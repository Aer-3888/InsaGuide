package test;

import main.TableCouples;
import main.Word;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TableCouplesTest {
    TableCouples t;
    @BeforeEach
    void setup() {
        this.t = new TableCouples();
    }

    @Test
    public void toStringEmpty() {
        assertEquals("<Empty>", t.toString());
    }

    @Test
    public void toStringNonEmpty() {
        t.ajouter(new Word("Californie"), new Word("California"));
        t.ajouter(new Word("Névada"), new Word("Nevada"));
        assertEquals("(\"californie\", \"california\")\n(\"névada\", \"nevada\")",
                t.toString());
    }

    @Test
    public void ajouterNull() {
        assertThrows(IllegalArgumentException.class,
                () -> t.ajouter(null, null));
        assertThrows(IllegalArgumentException.class,
                () -> t.ajouter(new Word("Californie"), null));
        assertThrows(IllegalArgumentException.class,
                () -> t.ajouter(null, new Word("California")));
    }

    @Test
    public void singleAddOK() {
        assertDoesNotThrow(() -> t.ajouter(new Word("Californie"), new Word("California")));
    }

    @Test
    public void addWithUpdate() {
        t.ajouter(new Word("Californie"), new Word("California"));
        assertDoesNotThrow(() -> t.ajouter(new Word("Californie"), new Word("lol vandalism")));
        assertEquals("(\"californie\", \"lol vandalism\")", t.toString());
    }

    @Test
    public void addCollision() {
        t.ajouter(new Word("Californie"), new Word("California"));
        assertDoesNotThrow(() -> t.ajouter(new Word("Calorimétrie"), new Word("calorimetry")));
    }

    @Test
    public void addCollisionWithUpdate() {
        t.ajouter(new Word("Californie"), new Word("California"));
        t.ajouter(new Word("Calorimétrie"), new Word("calorimetry"));
        assertDoesNotThrow(() -> t.ajouter(new Word("Calorimétrie"), new Word("more vandalism")));
        assertEquals("(\"californie\", \"california\")\n(\"calorimétrie\", \"more vandalism\")", t.toString());
    }

    @Test
    public void addAlreadyExistingIsFalse() {
        t.ajouter(new Word("Californie"), new Word("California"));
        assertFalse(t.ajouter(new Word("Californie"), new Word("California")));
    }

    @Test
    public void addCollisionAlreadyExistingIsFalse() {
        t.ajouter(new Word("Californie"), new Word("California"));
        t.ajouter(new Word("Calorimétrie"), new Word("calorimetry"));
        assertFalse(t.ajouter(new Word("Calorimétrie"), new Word("Calorimetry")));
    }

    @Test
    public void translateExisting() {
        this.importationMassive();
        assertEquals(new Word("boot"), t.traduire(new Word("amorce")));
    }

    @Test
    public void translateAbsent() {
        assertNull(t.traduire(new Word("Antérieur")));
    }

    void importationMassive() {
        t.ajouter( new Word("Accès direct"), new Word("direct access, random access") );
        t.ajouter( new Word("Accès séquentiel"), new Word("serial access") );
        t.ajouter( new Word("Afficher"), new Word("to display") );
        t.ajouter( new Word("Algorithmique"), new Word("algorithmics") );
        t.ajouter( new Word("Amorce"), new Word("boot") );
        t.ajouter( new Word("Amorcer"), new Word("to boot") );
        t.ajouter( new Word("Antémémoire"), new Word("cache memory, cache storage") );
        t.ajouter( new Word("Anticrénelage"), new Word("antialiasing") );
        t.ajouter( new Word("Appariement de formes"), new Word("pattern matching") );
        t.ajouter( new Word("Ardoise électronique"), new Word("notepad computer") );
        t.ajouter( new Word("Arrière-plan (d'), "), new Word("background") );
        t.ajouter( new Word("Autodocumenté"), new Word("self documented") );
        t.ajouter( new Word("Autonome"), new Word("off-line, offline") );
        t.ajouter( new Word("Banque de données"), new Word("data bank") );
        t.ajouter( new Word("Base de connaissances"), new Word("knowledge base") );
        t.ajouter( new Word("Base de données"), new Word("data base") );
        t.ajouter( new Word("Bit"), new Word("bit") );
        t.ajouter( new Word("Bloc"), new Word("block") );
        t.ajouter( new Word("Bogue"), new Word("bug") );
        t.ajouter( new Word("Boule de commande"), new Word("trackball, rolling ball") );
        t.ajouter( new Word("Bus"), new Word("bus") );
        t.ajouter( new Word("Cadre"), new Word("frame") );
        t.ajouter( new Word("Calcul intensif"), new Word("supercomputing") );
        t.ajouter( new Word("Clicher"), new Word("to dump") );
        t.ajouter( new Word("Cliquer"), new Word("to click") );
        t.ajouter( new Word("Codet"), new Word("code element") );
        t.ajouter( new Word("Connectabilité"), new Word("connectivity") );
        t.ajouter( new Word("Connexion"), new Word("log in, log on") );
        t.ajouter( new Word("Connexité"), new Word("connectivity") );
        t.ajouter( new Word("Coprocesseur"), new Word("coprocessor") );
        t.ajouter( new Word("Courtier"), new Word("broker") );
        t.ajouter( new Word("Crénelage"), new Word("aliasing") );
        t.ajouter( new Word("Déboguer"), new Word("to debug") );
        t.ajouter( new Word("Débogueur"), new Word("debugger") );
        t.ajouter( new Word("Défaillance"), new Word("failure") );
        t.ajouter( new Word("Défilement"), new Word("scrolling") );
        t.ajouter( new Word("Dessineur"), new Word("drawing software") );
        t.ajouter( new Word("Dévideur"), new Word("streamer") );
        t.ajouter( new Word("Didacticiel"), new Word("courseware, teachware") );
        t.ajouter( new Word("Disque optique compact"), new Word("CD-ROM") );
        t.ajouter( new Word("Disquette"), new Word("diskette, floppy disk") );
        t.ajouter( new Word("Donnée"), new Word("data") );
        t.ajouter( new Word("Échange de données informatisé"), new Word("electronic data interchange, EDI") );
        t.ajouter( new Word("Écran pixélisé"), new Word("bit map screen") );
        t.ajouter( new Word("Écran tactile"), new Word("touch screen") );
        t.ajouter( new Word("Éditeur"), new Word("editor") );
        t.ajouter( new Word("Éditique"), new Word("electronic publishing") );
        t.ajouter( new Word("Élément binaire"), new Word("bit") );
        t.ajouter( new Word("En ligne"), new Word("on-line") );
        t.ajouter( new Word("Étiquette"), new Word("label") );
        t.ajouter( new Word("Évolution d'un système"), new Word("upgrade") );
        t.ajouter( new Word("Exécuteur"), new Word("runtime software") );
        t.ajouter( new Word("Externalisation"), new Word("outsourcing") );
        t.ajouter( new Word("Forme"), new Word("pattern") );
        t.ajouter( new Word("Fusionner"), new Word("to merge") );
        t.ajouter( new Word("Grapheur"), new Word("graphics software") );
        t.ajouter( new Word("Grappe"), new Word("cluster") );
        t.ajouter( new Word("Groupe"), new Word("cluster") );
        t.ajouter( new Word("Heuristique"), new Word("heuristics") );
        t.ajouter( new Word("Icône"), new Word("icon") );
        t.ajouter( new Word("Iconiser"), new Word("to iconize, to stow") );
        t.ajouter( new Word("Implanter"), new Word("to implement") );
        t.ajouter( new Word("Implémenter"), new Word("to implement") );
        t.ajouter( new Word("Infogérance"), new Word("facilities management, F.M") );
        t.ajouter( new Word("Ingénierie inverse"), new Word("reverse engineering") );
        t.ajouter( new Word("Instaurer"), new Word("to set") );
        t.ajouter( new Word("Instruction"), new Word("instruction, statement") );
        t.ajouter( new Word("Intelligence artificielle"), new Word("artificial intelligence") );
        t.ajouter( new Word("Invite"), new Word("prompt") );
        t.ajouter( new Word("Langage à objets"), new Word("object-oriented language") );
        t.ajouter( new Word("Listage"), new Word("listing") );
        t.ajouter( new Word("Lister"), new Word("to list") );
        t.ajouter( new Word("Logement"), new Word("slot") );
        t.ajouter( new Word("Logiciel"), new Word("software") );
        t.ajouter( new Word("Logiciel contributif"), new Word("shareware") );
        t.ajouter( new Word("Logiciel de groupe"), new Word("groupware") );
        t.ajouter( new Word("Logiciel public"), new Word("freeware") );
        t.ajouter( new Word("Macroordinateur"), new Word("mainframe") );
        t.ajouter( new Word("Manche à balai"), new Word("joystick") );
        t.ajouter( new Word("Mappe"), new Word("map") );
        t.ajouter( new Word("Marquage"), new Word("highlighting") );
        t.ajouter( new Word("Matériel"), new Word("hardware") );
        t.ajouter( new Word("Mémoire"), new Word("storage memory") );
        t.ajouter( new Word("Mémoire de masse"), new Word("mass storage") );
        t.ajouter( new Word("Mémoire morte"), new Word("ROM, read only memory") );
        t.ajouter( new Word("Mémoire tampon"), new Word("buffer") );
        t.ajouter( new Word("Mémoire vive"), new Word("RAM, random access memory") );
        t.ajouter( new Word("Messagerie électronique"), new Word("message handling, electronic mail") );
        t.ajouter( new Word("Microédition"), new Word("desktop publishing") );
        t.ajouter( new Word("Micromisation"), new Word("downsizing") );
        t.ajouter( new Word("Micromiser"), new Word("to downsize") );
        t.ajouter( new Word("Microordinateur"), new Word("microcomputer") );
        t.ajouter( new Word("Microprogramme"), new Word("firmware") );
        t.ajouter( new Word("Mise à niveau"), new Word("upgrade") );
        t.ajouter( new Word("Mise en réseau"), new Word("networking") );
        t.ajouter( new Word("Mode dialogué"), new Word("conversational mode") );
        t.ajouter( new Word("Morphage"), new Word("morphing") );
        t.ajouter( new Word("Mot-clé"), new Word("keyword") );
        t.ajouter( new Word("Moteur d'inférence"), new Word("inference engine") );
        t.ajouter( new Word("Multiprocesseur"), new Word("multi-processor") );
        t.ajouter( new Word("Neurone formel"), new Word("artificial neurone") );
        t.ajouter( new Word("Numérique"), new Word("digital, numerical, numeric") );
        t.ajouter( new Word("Numériser"), new Word("to digitize") );
        t.ajouter( new Word("Numéro d'urgence"), new Word("hot line") );
        t.ajouter( new Word("Octet"), new Word("byte") );
        t.ajouter( new Word("Ordinateur"), new Word("computer") );
        t.ajouter( new Word("Ordinateur bloc-notes"), new Word("notebook computer") );
        t.ajouter( new Word("Ordinateur de poche"), new Word("palmtop computer, pocket computer") );
        t.ajouter( new Word("Ordinateur portable"), new Word("portable computer") );
        t.ajouter( new Word("Ordinateur portatif"), new Word("laptop computer") );
        t.ajouter( new Word("Ordinateur de table"), new Word("desktop computer") );
        t.ajouter( new Word("Organiseur"), new Word("organizer") );
        t.ajouter( new Word("Panne"), new Word("fault") );
        t.ajouter( new Word("Partage de temps"), new Word("time sharing") );
        t.ajouter( new Word("Permutation"), new Word("swap") );
        t.ajouter( new Word("Photostyle"), new Word("light pen") );
        t.ajouter( new Word("Pilote"), new Word("driver") );
        t.ajouter( new Word("Pixel"), new Word("pixel") );
        t.ajouter( new Word("Pointeur"), new Word("pointer") );
        t.ajouter( new Word("Police"), new Word("font") );
        t.ajouter( new Word("Processeur"), new Word("processor") );
        t.ajouter( new Word("Processeur vectoriel"), new Word("array processor") );
        t.ajouter( new Word("Progiciel"), new Word("package") );
        t.ajouter( new Word("Programmation par objets"), new Word("object-oriented programming") );
        t.ajouter( new Word("Raccourci clavier"), new Word("hot key") );
        t.ajouter( new Word("Réalité virtuelle"), new Word("virtual reality") );
        t.ajouter( new Word("Réamorcer"), new Word("to reboot") );
        t.ajouter( new Word("Référentiel"), new Word("repository") );
        t.ajouter( new Word("Réinitialiser"), new Word("to reset") );
        t.ajouter( new Word("Relancer"), new Word("to restart") );
        t.ajouter( new Word("Répertoire"), new Word("directory") );
        t.ajouter( new Word("Requête"), new Word("request") );
        t.ajouter( new Word("Réseau informatique"), new Word("computer network") );
        t.ajouter( new Word("Réseau local"), new Word("local area network") );
        t.ajouter( new Word("Réseau neuronal"), new Word("neural network") );
        t.ajouter( new Word("Réseautique"), new Word("networking") );
        t.ajouter( new Word("Restaurer"), new Word("to reset ; to restore") );
        t.ajouter( new Word("Résumé"), new Word("abstract") );
        t.ajouter( new Word("Révision"), new Word("release") );
        t.ajouter( new Word("Scanneur"), new Word("scanner") );
        t.ajouter( new Word("Scrutation"), new Word("polling") );
        t.ajouter( new Word("Secours (de)"), new Word("back up") );
        t.ajouter( new Word("Secours informatique"), new Word("back-up") );
        t.ajouter( new Word("Serveur"), new Word("on line data service") );
        t.ajouter( new Word("Souris"), new Word("mouse") );
        t.ajouter( new Word("Spoule"), new Word("spool") );
        t.ajouter( new Word("Surbrillance"), new Word("brightening") );
        t.ajouter( new Word("Survol"), new Word("browsing") );
        t.ajouter( new Word("Système exclusif"), new Word("proprietary system") );
        t.ajouter( new Word("Système expert"), new Word("expert system") );
        t.ajouter( new Word("Système d'exploitation"), new Word("operating system") );
        t.ajouter( new Word("Système de gestion de base de données"), new Word("Data Base Management System, D.B.M.S") );
        t.ajouter( new Word("Tableur"), new Word("spreadsheet") );
        t.ajouter( new Word("Tel écran - tel écrit"), new Word("wysiwyg") );
        t.ajouter( new Word("Télémaintenance"), new Word("remote maintenance") );
        t.ajouter( new Word("Télétraitement"), new Word("teleprocessing") );
        t.ajouter( new Word("Télétraitement par lots"), new Word("remote batch teleprocessing") );
        t.ajouter( new Word("Temps réel"), new Word("real time") );
        t.ajouter( new Word("Test de performance"), new Word("benchmark") );
        t.ajouter( new Word("Texte intégral (en)"), new Word("full text") );
        t.ajouter( new Word("Texteur"), new Word("word processor, text processor") );
        t.ajouter( new Word("Tirage"), new Word("hard copy") );
        t.ajouter( new Word("Tolérance aux pannes"), new Word("fault tolerance") );
        t.ajouter( new Word("Tolérant aux pannes"), new Word("fault tolerant") );
        t.ajouter( new Word("Traitement automatique des données"), new Word("automatic data processing (A.D.P.)") );
        t.ajouter( new Word("Traitement par lots"), new Word("batch processing") );
        t.ajouter( new Word("Traitement de texte"), new Word("word processing, text processing") );
        t.ajouter( new Word("Tutoriel"), new Word("tutorial") );
        t.ajouter( new Word("Version"), new Word("release, version") );
        t.ajouter( new Word("Visu"), new Word("display device") );
    }

    @Test
    void importRunsWell() {
        assertDoesNotThrow(this::importationMassive);
    }

    @Test
    void toStringWorks() {
        this.importationMassive();
        System.out.print(this.t.toString());
        System.out.println("this should be glued to the side at the end");
    }
}
