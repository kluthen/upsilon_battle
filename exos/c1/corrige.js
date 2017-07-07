/**
 * En javascript les commentaires sont indiqué de deux facons: 
 *  soit par /* */
/*  soit par // 

    Pour tester le fichier, il suffit d'appeler node exos/c1/corrige.js
*/

console.log("Exercice 1")

/**
Sachant le jour(L / M / Me / J / V / S / D) courant, quel jour on sera dans x jours.
*/

jours = ["lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"]
aujourdhui = 4
dans_x_jours = 45

// https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators
// l'operateur % donne le reste d'une division.
jour_cible = (aujourdhui + dans_x_jours) % 7
console.log("Dans " + dans_x_jours + " jours, sachant que nous somme un " + jours[aujourdhui] + " nous serons un " + jours[jour_cible])


console.log("Exercice 2")

/** 
 * Créer un tableau à deux dimensions de largeur 10 et de hauteur 10, la remplir de 0, assurer que tout le tour du tableau soit remplis de X.
 *   Exemple:
 *   XXXXXX
 *   X0000X
 *   XXXXXX
 */

// methode feignant: 

tableau = [
    ["X", "X", "X", "X", "X", "X", "X", "X", "X", "X"],
    ["X", "0", "0", "0", "0", "0", "0", "0", "0", "X"],
    ["X", "0", "0", "0", "0", "0", "0", "0", "0", "X"],
    ["X", "0", "0", "0", "0", "0", "0", "0", "0", "X"],
    ["X", "0", "0", "0", "0", "0", "0", "0", "0", "X"],
    ["X", "0", "0", "0", "0", "0", "0", "0", "0", "X"],
    ["X", "0", "0", "0", "0", "0", "0", "0", "0", "X"],
    ["X", "0", "0", "0", "0", "0", "0", "0", "0", "X"],
    ["X", "0", "0", "0", "0", "0", "0", "0", "0", "X"],
    ["X", "X", "X", "X", "X", "X", "X", "X", "X", "X"],
]

// methode class ;p

// on créer un tableau qui servira de resultat..
tableau_2 = []

// on va faire varier ligne de 0 a 9 

// var ligne = 0; on commence a ligne = 0
// ligne < 10 ; tant que ligne < 10 
// ligne++ est equivalent a ligne + 1
for (var ligne = 0; ligne < 10; ligne++) {

    // on créer un tableau qui contiendra notre ligne :)
    ligne_c = []

    // on fait la meme chose pour les colones. 
    for (var colone = 0; colone < 10; colone++) {
        // cas de la premiere et derniere ligne.
        if (ligne == 0 || ligne == 9) {
            ligne_c.push("X");

            // cas de la premiere et derniere colone. 
        } else if (colone == 0 || colone == 9) {
            ligne_c.push("X");
        } else {
            // le reste :) on remplis de 0 
            ligne_c.push("0");
        }
    }
    // on ajoute au tableau la nouvelle ligne.
    tableau_2.push(ligne_c);
}

console.log("Exercice 3");
/**
Faire une fonction qui imprime le tableau sur la sortie standard(params: le tableau)

*/

print = function(tableau) {
    // on itere sur tout les elements du tableau.
    // on se rappelera que tableau.length donne la taille du tableau.
    for (var i = 0; i < tableau.length; i++) {
        // <liste>.join(seperateur) : ici: tableau[i].join("") permet d'ajouter tout les elements les un apres les autres. 
        // par exemple [1,2,3].join("-") produirai 1-2-3
        console.log(tableau[i].join(""))
    }
}

print(tableau_2);


console.log("Exercice 4");
/**
Faire une fonction qui retourne l’ objet a une position donnée du tableau(params: tableau, x, y) retourne {: ok, valeur }, {: erreur,: x_invalide }, {: erreur,: y_invalide }

*/

search = function(tableau, x, y) {
    // en javascript and s'ecris &&
    // ici on test que x est dans le tableau 
    // (sinon javascript pas content)
    if (x >= 0 && x < tableau.length) {
        ligne = tableau[x];
        // même chose avec les colones.
        if (y >= 0 && y < ligne.length) {
            return { ok: ligne[y] }
        } else {
            return { erreur: "y_invalide" }
        }
    } else
        return { erreur: "x_invalide" }
}

console.log(search(tableau, 5, 5).ok);
// pour affichier les structure, il vaux mieu utiliser JSON.stringify.
// cela permet de transfomer la structure en JSON
// on vera ce qu'est JSON un autre jour ;) mais pour faire simple, cela transforme un objet en string :)
console.log(JSON.stringify(search(tableau, 0, 99)));
console.log(JSON.stringify(search(tableau, 99, 5)));

console.log("Exercice 5");
/** 
 * Faire une fonction qui génère le tableau précédant, prenant en paramètre la hauteur et la largeur, elle doit renvoyer le {: ok, tableau }
ou {: erreur,: hauteur }
ou {: erreur,: largeur }
en cas de paramètres invalide.(paramètre valide: > 5)

*/

create = function(lignes, colones) {
    if (lignes <= 3) {
        return { erreur: "lignes" };
    }
    if (colones <= 3) {
        return { erreur: "colones" };
    }

    tableau = [];
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
        tableau.push(ligne_c)
    }

    return { ok: tableau };
}

tableau = create(5, 5);
print(tableau.ok);
mauvais_tableau = create(0, 3);
console.log(JSON.stringify(mauvais_tableau))

console.log("Exercice 6");
/**
Faire une fonction qui ajoute un marqueur dans le tableau(params: tableau, marqueur(A, B, C, D), position).
En cas de positionnement valide(
    case cible = 0) renvois {: ok, nouveau tableau }, sinon {: erreur,: position_invalide }

*/

put = function(tableau, marqueur, x, y) {
    res = search(tableau, x, y);
    // On test qu'il n'y a pas d'erreur. 
    if (res.erreur == undefined) {
        tableau[x][y] = marqueur;
        return { ok: tableau };
    } else {
        return { erreur: "position_invalide" };
    }
}

insert = function(tableau, marqueur, x, y) {
    ok = marqueur == "A" ||
        marqueur == "B" ||
        marqueur == "C" ||
        marqueur == "D";

    if (!ok) {
        return { erreur: "marqueur_invalide" }
    }

    res = search(tableau, x, y);
    if (res.erreur == undefined) {
        if (res.ok == "0") {
            return put(tableau, marqueur, x, y);
        } else {
            return { erreur: "position_invalide" }
        }
    } else {
        return { erreur: "position_invalide" }
    }
}

t = create(5, 5).ok;
print(t);
nouveau_tableau = insert(t, "A", 2, 2).ok;
print(nouveau_tableau);
// Attention :) Vous pourrez constaté que la table d'origne a été modifiée ! 
print(t);
fail = insert(t, "O", 344, 232);
console.log(JSON.stringify(fail));

console.log("Exercice 7");
/*
Faire une fonction qui déplace un marqueur dans le tableau(params: tableau, position du marqueur, nouvelle position)
Valid: position dans le tableau = A B C D, nouvelle position = 0 {: ok, nouveau tableau }
sinon {: erreur,: origine_invalide }
sinon {: erreur,: cible_invalide }
*/

move = function(tableau, origin_x, origin_y, x, y) {
    origin = search(tableau, origin_x, origin_y);
    if (origin.erreur == undefined) {
        if (origin.ok == "A" ||
            origin.ok == "B" ||
            origin.ok == "C" ||
            origin.ok == "D") {
            target = insert(tableau, origin.ok, x, y);
            if (target.erreur == undefined) {
                res = put(target.ok, "0", origin_x, origin_y);
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
        return { erreur: "origine_invalide" };
    }
}

tableau = create(5, 5).ok;
print(tableau);
nouveau_tableau = insert(tableau, "A", 2, 2).ok;
print(nouveau_tableau);
tableau_2 = move(nouveau_tableau, 2, 2, 3, 3).ok;
print(tableau_2);