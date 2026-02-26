# 💻 Unité Arithmétique et Logique (UAL/ALU) 4-bits sur FPGA Basys 3

Réalisé par :Taieb Dabbech | Année : 2026

## 📝 Description du Projet
Ce projet consiste en la conception, la simulation et l'implémentation matérielle d'une Unité Arithmétique et Logique (UAL) 4-bits sur une carte FPGA **Basys 3 (Xilinx Artix-7)**. Le projet a été entièrement codé en **VHDL** via l'environnement **Vivado**.

L'objectif de ce projet est de démontrer la maîtrise de la logique combinatoire et séquentielle en créant un mini-processeur capable d'exécuter plusieurs opérations matérielles, tout en affichant les données en temps réel sur un afficheur 7-segments et des LEDs.

## 🚀 Fonctionnalités et Modules Implémentés
Le projet est architecturé de manière modulaire. Voici les blocs matériels implémentés :

* **Opérations Combinatoires :**
    * `multiplier.vhd` : Multiplicateur matériel 4-bits avec gestion du dépassement (élargissement du bus de données).
    * `comparator.vhd` : Comparateur logique générant des drapeaux d'état (Flags : A>B, A<B, A=B).
    * **XOR** : Porte logique Ou-Exclusif bit à bit.
* **Opérations Séquentielles :**
    * `lfsr.vhd` : Générateur de nombres pseudo-aléatoires (Linear Feedback Shift Register).
    * `async_counter.vhd` : Compteur asynchrone contrôlé par bouton poussoir.
    * `shift_register.vhd` : Registre à décalage (gauche/droite).
* **Gestion de l'Affichage et du Temps :**
    * `sevenseg_driver.vhd` : Contrôleur pour l'afficheur 7-segments (conversion Binaire vers Hexadécimal avec multiplexage temporel).
    * `clock_divider.vhd` : Diviseur d'horloge pour adapter les signaux de la carte aux composants physiques.
    * `ual_core.vhd` & `top_basys3.vhd` : Fichiers d'entité principale reliant l'UAL aux broches physiques de la carte.

## 🛠️ Matériel Utilisé
* **Carte :** Digilent Basys 3 (FPGA Xilinx Artix-7)
* **Logiciel :** Xilinx Vivado
* **Langage :** VHDL

## 🎮 Guide d'Utilisation (Mapping de la carte)
Pour tester l'architecture sur la carte physique, référez-vous au fichier de contraintes `basys3_ual_2026.xdc` :

* **Entrées de données :**
    * `SW0 à SW3` : Entrée A (4 bits)
    * `SW4 à SW7` : Entrée B (4 bits)
* **Sélecteur d'Opération (SEL) :**
    * Les interrupteurs restants (`SW8` et supérieurs) servent à sélectionner le code de l'opération à exécuter (ex: Multiplicateur, LFSR, Comparateur...).
* **Sorties Visuelles :**
    * **Afficheur 7-segments :** Affiche le motif `[Entrée B] | [Entrée A] | [Résultat Hexa]`.
    * **LEDs Vertes (`LD0` - `LD15`) :** Affichent l'état direct des interrupteurs, le résultat binaire en cours, et les drapeaux (Flags) du comparateur.
* **Contrôles (Boutons Poussoirs) :**
    * `BTNU` (Haut) : Horloge manuelle / Validation d'une étape (Shift, LFSR, Compteur).
    * `BTNL` (Gauche) : Chargement d'une donnée (Load).
    * `BTNC` (Centre) : Reset asynchrone général.

## 📸 Démonstration
*(Note : Regardez la vidéo `8fac5...mp4` et l'image `carte active.jpg` incluses dans ce dépôt pour voir l'UAL en plein fonctionnement matériel !)*
### 🎛️ Décodage des Opérations (Sélecteur SEL)
Le choix de l'opération s'effectue via les interrupteurs dédiés au sélecteur `SEL`. Voici le mappage complet des 8 opérations intégrées dans l'UAL :

| Code `SEL` (Binaire) | Opération Exécutée | Type | Comportement & Affichage attendu |
| :---: | :--- | :--- | :--- |
| **`0000`** | **XOR (Ou Exclusif)** | Combinatoire | Applique un XOR bit-à-bit entre l'Entrée A et l'Entrée B. |
| **`0001`** | **LFSR (Aléatoire)** | Séquentiel | Génère une séquence pseudo-aléatoire. Avance avec `BTNU`, Reset avec `BTNC`. |
| **`0010`** | **Compteur (Counter)** | Séquentiel | Compte de manière croissante. S'incrémente de +1 à chaque pression sur `BTNU`. |
| **`0011`** | **Shift Droit** | Séquentiel | Décale les bits vers la droite. Charger avec `BTNL`, décaler avec `BTNU`. |
| **`0100`** | **Shift Gauche** | Séquentiel | Décale les bits vers la gauche (équivaut à une multiplication par 2). |
| **`0101`** | **Comparateur** | Logique | Compare A et B. Active les LEDs de statut (Flags) pour : `A > B`, `A < B`, ou `A = B`. |
| **`0110`** | **Multiplicateur** | Combinatoire | Multiplie A × B. Le résultat (jusqu'à 8 bits) s'affiche en Hexadécimal sur les 7-segments. |
| **`0111`** | **Affichage (Pass-through)** | Routage | Aucune opération. Affiche directement et fidèlement les entrées A et B sur le 7-segments pour vérification. |

*(Note : Si vous testez la carte physiquement, rappelez-vous que `1` signifie que l'interrupteur est levé, et `0` qu'il est baissé).*
