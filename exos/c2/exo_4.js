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


$("#player_list").hide();
$("#player_data").hide();
$('#board').hide();

$('#begin_btn').on('click', function() {
    $('#screen_top').hide();
    width = $('#max_width').val();
    height = $('#max_height').val();
});