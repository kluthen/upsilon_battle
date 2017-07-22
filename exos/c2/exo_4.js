// JS associer a l'exercice 4. 
// Permet de mettre en place un mode multi joueur sur un même ecran. 

// Avant tout, petite fonction pour pouvoir ecrire des messages sur la page web
// Histoire d'etre au courant de ce qu'il se passe :)
logging = function(to_log) {
    // on a jQuery a disposition a tout moment ici ;)
    // acceder au contenu d'un text area se fait avec la fonction val().
    // on ajoute la date, pour reference :)
    date_now = new Date(Date.now())

    $('#log').val(date_now.getHours() + ':' +
        date_now.getMinutes() + ':' +
        date_now.getSeconds() + ' > ' +
        to_log + ('\n') + $('#log').val());
}

// on desactive le text area ... de facon a ce qu'on ne puisse pas ecrire dedans.
$("#log").attr("disabled", "disabled");

logging("--- INITIALISATION ---");

// je reprend les reponses du cours 1 pour preparé la sauce ... //
// Pour eviter un peu le bordel, je met tout ca dans un objet   //
// Qui contiendra aussi le contexte de jeu                      //
// Quelques menues modifications pour rendre le tout plus       // 
// agreable a utiliser                                          //
// ############################################################ //

/**
Faire une fonction qui retourne l’ objet a une position donnée du tableau(params: tableau, x, y) retourne {: ok, valeur }, {: erreur,: x_invalide }, {: erreur,: y_invalide }

*/
jeu = {

    tableau: [],
    joueurs: [],
    width: 3,
    height: 3,
    current_player: 0,


    print: function() {
        // on itere sur tout les elements du tableau.
        // on se rappelera que tableau.length donne la taille du tableau.
        for (var i = 0; i < height; i++) {
            // <liste>.join(seperateur) : ici: tableau[i].join("") permet d'ajouter tout les elements les un apres les autres. 
            // par exemple [1,2,3].join("-") produirai 1-2-3
            console.log(this.tableau[i].join(""))
        }
    },

    search: function(x, y) {
        // en javascript and s'ecris &&
        // ici on test que x est dans le tableau 
        // (sinon javascript pas content)
        if (y >= 0 && y < this.tableau.length) {
            ligne = this.tableau[y];
            // même chose avec les colones.
            if (x >= 0 && y < ligne.length) {
                return { ok: ligne[x] }
            } else {
                return { erreur: "y_invalide" }
            }
        } else
            return { erreur: "x_invalide" }
    },
    /** 
     * Faire une fonction qui génère le tableau précédant, prenant en paramètre la hauteur et la largeur, elle doit renvoyer le {: ok, tableau }
    ou {: erreur,: hauteur }
    ou {: erreur,: largeur }
    en cas de paramètres invalide.(paramètre valide: > 5)

    */

    create: function(lignes, colones) {
        if (lignes <= 3) {
            return { erreur: "lignes" };
        }
        if (colones <= 3) {
            return { erreur: "colones" };
        }

        this.tableau = [];
        for (var ligne = 0; ligne < lignes; ligne++) {
            ligne_c = []
            for (var colone = 0; colone < colones; colone++) {
                // on notera qu'en javascript 
                // or s'ecris ||
                if (ligne == 0 ||
                    ligne == lignes - 1) {
                    ligne_c.push("X");
                } else if (colone == 0 ||
                    colone == colones - 1) {
                    ligne_c.push("X");
                } else {
                    ligne_c.push("0");
                }
            }
            this.tableau.push(ligne_c)
        }
        this.width = colones;
        this.height = lignes;
        return { ok: this.tableau };
    },

    /**
    Faire une fonction qui ajoute un marqueur dans le tableau(params: tableau, marqueur(A, B, C, D), position).
    En cas de positionnement valide(
        case cible = 0) renvois {: ok, nouveau tableau }, sinon {: erreur,: position_invalide }

    */

    put: function(marqueur, x, y) {
        res = this.search(x, y);
        // On test qu'il n'y a pas d'erreur. 
        if (res.erreur == undefined) {
            this.tableau[y][x] = marqueur;
            return { ok: this.tableau };
        } else {
            return { erreur: "position_invalide" };
        }
    },

    insert: function(marqueur, x, y) {
        ok = marqueur == "A" ||
            marqueur == "B" ||
            marqueur == "C" ||
            marqueur == "D";

        if (!ok) {
            return { erreur: "marqueur_invalide" }
        }

        res = this.search(x, y);
        if (res.erreur == undefined) {
            if (res.ok == "0") {
                return this.put(marqueur, x, y);
            } else {
                return { erreur: "position_invalide" }
            }
        } else {
            return { erreur: "position_invalide" }
        }
    },

    /*
    Faire une fonction qui déplace un marqueur dans le tableau(params: tableau, position du marqueur, nouvelle position)
    Valid: position dans le tableau = A B C D, nouvelle position = 0 {: ok, nouveau tableau }
    sinon {: erreur,: origine_invalide }
    sinon {: erreur,: cible_invalide }
    */

    move: function(origin_x, origin_y, x, y) {
        origin = this.search(origin_x, origin_y);
        if (origin.erreur == undefined) {
            if (origin.ok == "A" ||
                origin.ok == "B" ||
                origin.ok == "C" ||
                origin.ok == "D") {
                target = this.insert(origin.ok, x, y);
                if (target.erreur == undefined) {
                    res = this.put("0", origin_x, origin_y);
                    if (res.erreur == undefined) {
                        return { ok: res.ok };
                    } else {
                        return { erreur: "cible_invalide" };
                    }
                } else {
                    return { erreur: "cible_invalide" };
                }
            } else {
                return { erreur: "origine_invalide" };
            }
        } else {
            return { erreur: "origine_invalide, " + origin.erreur };
        }
    },

    // Ajoute jusqu'a un certain nombre d'obstacle dans la carte. 
    addFun: function(max = 15) {
        nb = Math.floor((Math.random() * max) + 1);
        logging("On vas ajouter " + nb + " obstacle")
        for (var i = 0; i < nb; i++) {
            y = Math.floor((Math.random() * this.height));
            x = Math.floor((Math.random() * this.width));
            // put ne controle rien
            if (x != 0 && y != 0) {
                this.put('%', x, y)
                logging("Dont un ici: " + x + "," + y);
            }
        }
    },

    // on va commencer le jeu ici ;)

    begin: function() {
        // preparation des joueurs etc etc
        logging("Initialisation des joueurs ... ");

        // on s'assure qu'il soit vide ;)
        this.joueurs = []

        for (var i = 0; i < 3; i++) {
            joueur = {
                x: 0,
                y: 0,
                pv: 3,
                pm: 3,
                pa: 1,
                name: "Player " + (1 + i),
                marqueur: ''
            };
            this.joueurs.push(joueur);
        }

        logging("Positionnement initiaux ...");

        // forcing: joueur 1 a gauche, 2 a droite, 3 en bas. 
        // a gauche, donc x = 1 ( 0 y a le mur de bord de carte ;) ).

        // while permet d'effectué un bout de code tant qu'on est pas satisfait.
        // la satisfaction est indiqué par une condition qui tant qu'elle est positive
        // indique qu'on est toujours entrain de cherché.
        // on peux sortir en avance avec break;


        while (true) {
            y = Math.floor(Math.random() * (this.height - 1) + 1);
            res = this.search(1, x);
            if (res.erreur == undefined) {
                if (res.ok == '0') {
                    // on a trouvé une bonne position !
                    this.joueurs[0].x = 1;
                    this.joueurs[0].y = y;
                    this.joueurs[0].marqueur = 'A';
                    this.insert('A', 1, y)
                    el_depart = this.seek(1, y);
                    el_depart.toggleClass("player_1");
                    logging("Player 1 position initiale: 1," + y)
                    break;
                }
            }
        }

        while (true) {
            y = Math.floor(Math.random() * (this.height - 1) + 1)
            res = this.search(this.width - 2, y);
            console.log(res);
            if (res.erreur == undefined) {
                if (res.ok == '0') {
                    // on a trouvé une bonne position !
                    this.joueurs[1].x = this.width - 2;
                    this.joueurs[1].y = y;
                    this.joueurs[1].marqueur = 'B';
                    this.insert('B', this.width - 2, y)
                    el_depart = this.seek(this.width - 2, y);
                    el_depart.toggleClass("player_2");
                    logging("Player 2 position initiale: " + (this.width - 2) + "," + y)
                    break;
                }
            }
        }

        while (true) {
            x = Math.floor(Math.random() * this.width);
            res = this.search(x, 8);
            if (res.erreur == undefined) {
                if (res.ok == '0') {
                    // on a trouvé une bonne position !
                    this.joueurs[2].x = x;
                    this.joueurs[2].y = 8;
                    this.joueurs[2].marqueur = 'C';
                    this.insert('C', x, 8)
                    el_depart = this.seek(x, 8);
                    el_depart.toggleClass("player_3");
                    logging("Player 3 position initiale: " + x + "," + 8)
                    break;
                }
            }
        }


        this.print();
        logging("Tirage au sort du premier joueur");
        premier = Math.floor(Math.random() * 3);

        logging("Go Premier Joueur !");

        this.install();
        this.setCurrentPlayer(premier);
        return;
    },

    install: function() {
        // on verifie qu'elle n'ai pas djea qqc d'attacher. 
        $(".cellule").off('click');
        // install les EventListener sur tout les elements adequat ;) 
        $(".cellule").on('click', function() {
            // on notera que "this" est l'element local ( en format javascript standard et pas jQuery)
            // $(this) donne un objet js :)

            // position de la cellule: 
            x = $(this).attr("data-col");
            y = $(this).attr("data-row");

            logging("Click sur la cellule: " + x + "," + y);

            // on check rapidement la destination: 0 c'est un deplacement, non X et non % c'est une attaque.

            res = jeu.search(x, y);
            if (res.erreur == undefined) {
                if (res.ok == '0') { // c'est une case vide !
                    jeu.move_action(x, y);
                } else if (res.ok != 'X' && res.ok != '%') { // c'est un joueur !
                    jeu.attack_action(x, y);
                }
            } else {
                logging("On vien de cliqué sur une drole de case !");
            }
        });


        $("#pass_btn").off('click');
        $("#pass_btn").on('click', function() {
            jeu.pass();
        });

        logging("Installation des evenements OK !");
        return;
    },

    seek: function(x, y) {
        // va cherché l'objet jQuery qui correspond a la cellule :)
        res = this.search(x, y);
        if (res.erreur == undefined) {
            return $("#board table tr[data-row='" + y + "'] td[data-col='" + x + "']")
        } else {
            return res;
        }
        return;
    },

    display_current_player: function() {
        player = this.joueurs[this.current_player];
        $('#current_player').html(player.name);
        $('#player_pv').html(player.pv);
        $('#player_pm').html(player.pm);
        $('#player_pa').html(player.pa);
        // s'assure que le bouton Pass soit actif. 
        $('#pass_btn').removeAttr('disabled');
    },

    setCurrentPlayer: function(player_index) {
        // okay on nettoie un peu tout ca et on affiche les infos.
        this.current_player = player_index;
        player = this.joueurs[player_index];
        player.pm = 3;
        player.pa = 1;
        $('#player_data').show();

        this.display_current_player();


        el = this.seek(player.x, player.y);
        // on marque la tuile du joueur comme etant active.
        el.toggleClass("current");
        // on met le marqueur sur la piste d'ordre des joueurs. 
        $(".player.player_" + (player_index + 1)).toggleClass("current");

        logging("C'est le tour de " + player.name);
        logging("Derniere position: " + player.x + "," + player.y);
        return;
    },

    // return nouvel index pour le prochain joueur.
    // ou -1 pour fin de la partie.
    seekNextPlayer: function() {
        next = this.current_player + 1;
        while (true) {
            if (next > 2)
                next = 0;

            if (next == this.current_player) {
                // on a fait tout le tour ! 
                // personne ne fait l'affaire
                // donc le joueur courant a gagner !
                logging("Aucun autre challenger !");
                return -1;
            }

            cible = this.joueurs[next]
            if (cible.pv > 0) {
                logging("Prochain joueurs: " + cible.name)
                return next;
            }
            next = next + 1;
        }
        return;
    },

    move_action: function(x, y) {
        res = this.search(x, y);
        if (res.erreur == undefined) {
            // on calcule la distance avec la position du joueur courant.
            joueur = this.joueurs[this.current_player]
            distance = Math.abs(joueur.x - x) + Math.abs(joueur.y - y);
            if (distance <= joueur.pm) {
                origin = res;
                logging("Tentative de deplacement de: " + joueur.x + "," + joueur.y + " vers " + x + "," + y);
                res = this.move(joueur.x, joueur.y, x, y);
                this.print();
                if (res.erreur == undefined) {
                    el_depart = this.seek(joueur.x, joueur.y);
                    el_arrive = this.seek(x, y);
                    el_depart.toggleClass("player_" + (this.current_player + 1));
                    el_arrive.toggleClass("player_" + (this.current_player + 1));
                    el_depart.toggleClass("current");
                    el_arrive.toggleClass("current");
                    joueur.x = x;
                    joueur.y = y;
                    joueur.pm = joueur.pm - distance;
                    this.joueurs[this.current_player] = joueur;
                    this.display_current_player();
                } else {
                    // la case d'origine ne correspond pas a un marqueur.
                    logging("Données de jeu corrompue. " + res.erreur);
                }
            } else {
                logging("Deplacement invalise, pas assez de PM");
            }
        } else {
            logging("Deplacement vers la case " + x + "," + y + " est invalide !");
        }
        return;
    },

    attack_action: function(x, y) {
        joueur = this.joueurs[this.current_player];
        if (x == joueur.x && y == joueur.y) {
            logging("Mais non il devien fou et tente de s'attaquer lui même !");
        } else {
            // on cherche le joueur ciblé par ca position
            for (var i = 0; i < 3; i++) {
                p = this.joueurs[i];
                if (p.x == x && p.y == y) {
                    cible = p;
                    joueur = this.joueurs[this.current_player];
                    if (joueur.pa < 1) {
                        logging("Le joueur n'a pas assez de points d'actions !");
                        return;
                    } else {
                        cible.pv = cible.pv - 1;
                        joueur.pa = joueur.pa - 1;
                        this.joueurs[this.current_player] = joueur;
                        this.joueurs[i] = cible;
                        this.display_current_player();
                        logging("" + joueur.name + " inflige 1 blessure au joueur " + cible.name);
                        return;
                    }
                    return; // nous fait sortir de la boucle.
                }
            }

            logging("Aucune cible valide !");
        }
        return;
    },

    pass: function() {
        target = this.seekNextPlayer();
        if (target >= 0) {
            $(".current").toggleClass("current");
            this.setCurrentPlayer(target);
        } else {
            current = this.joueurs[this.current_player]
            logging("Fin de Partie ! Le joueur " + current.name + " gagne !");
            // raffiche la creation de carte
            $("#screen_top").show();
            // cache le panneau joueur.
            $("#player_data").hide();
            // desactive la table. 
            $(".cellule").off('click');
        }
        return;
    }
};

//                 On reprend le boulot ici                     //
//##############################################################//


$("#player_list").hide();
$("#player_data").hide();
$('#board').hide();




// Quand on click sur le bouton "Begin" qu'est ce qu'il se passe ... 
$('#begin_btn').on('click', function() {
    $('#screen_top').hide();

    width = $('#max_width').val();
    height = $('#max_height').val();
    obstacle = $('#max_obstacle').val();

    if (width > 20)
        width = 20;
    if (height > 20)
        height = 20;
    if (width < 3)
        width = 10;
    if (height < 10)
        height = 10;
    if (obstacle < 5)
        obstacle = 15;
    if (obstacle > 50)
        obstacle = 50;

    res = jeu.create(width, height);
    if (res.erreur != undefined) {
        logging("Mauvaise dimension du tableau ... On va utiliser un tableau de 10x10 !");
        res = jeu.create(10, 10);
    }

    jeu.joueurs = []


    // petite fonction qui va ajouter au hazard des % sur la carte
    // représentant des obstacles
    jeu.addFun(obstacle);

    jeu.print();

    // il faut donc l'afficher ! 
    // on s'assure que le contenu de l'element board est juste une table vide.;
    board_el = $('#board');
    board_el.html('<table></table>');

    board_tab = $('#board table');

    // va créer le tableau de toute piece. 
    for (var y = 0; y < jeu.height; y++) {
        // permet d'ajouter a la fin des fils une ligne.
        board_tab.append("<tr data-row='" + y + "'></tr>");
        // on recupere la nouvelle ligne.
        b_row = $("#board table tr[data-row='" + y + "']");
        for (var x = 0; x < jeu.width; x++) {
            // on ajoute a la fin des fils, une nouvelle cellule !
            b_row.append("<td class='cellule' data-row='" + y + "' data-col='" + x + "'>&nbsp;</td>");
            // on regarde ce qu'il y a sur cette cellule dans le tableau.
            res = jeu.search(x, y);
            if (res.erreur == undefined) {
                // si y a un obstacle ou une bordure, on l'ajoute.
                b_cell = $("#board table tr[data-row='" + y + "'] td[data-col='" + x + "']")
                if (res.ok == '%') {
                    b_cell.toggleClass("obstacle");
                } else if (res.ok == 'X') {
                    b_cell.toggleClass("bordure");
                }
            }
        }

    }

    jeu.begin();
    // on affiche le resultat !
    $('#board').show();
    $('#player_list').show();
});