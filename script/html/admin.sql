create or replace
PROCEDURE admin
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('LOLITA');
	htp.print('<link href="https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css" rel="stylesheet">');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1,'Administration LOLITA');
	htp.br;
	htp.header(2, 'Membre, Langue, CodeLolita');
	htp.print('<a class="btn btn-primary" href="afft_membre" >Voir la liste des membres</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_membre" >Ajouter un membre</a>');
	htp.hr;
	htp.print('<a class="btn btn-primary" href="afft_langue" >Voir la liste des langues</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_langue" >Creer une langue</a>');
	htp.hr;
	htp.print('<a class="btn btn-primary" href="afft_codelolita" >Voir la liste des codelolita</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_codelolita" >Creer un codelolita</a>');
	htp.header(2, 'Sujet, Message');
	htp.print('<a class="btn btn-primary" href="afft_sujet" >Voir la liste des sujets</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_sujet" >Creer un sujet</a>');
	htp.hr;
	htp.print('<a class="btn btn-primary" href="afft_message" >Voir la liste des messages</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_message" >Creer un message</a>');
	htp.header(2, 'Domaine, Categorie');
	htp.print('<a class="btn btn-primary" href="afft_domaine" >Voir la liste des domaines</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_domaine" >Creer un domaine</a>');
	htp.hr;
	htp.print('<a class="btn btn-primary" href="afft_categorie" >Voir la liste des categories</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_categorie" >Creer une categorie</a>');
	htp.header(2, 'Societe');
	htp.print('<a class="btn btn-primary" href="afft_societe" >Voir la liste des societes</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_societe" >Creer une societe</a>');
	htp.hr;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;