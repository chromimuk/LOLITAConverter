CREATE OR REPLACE
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
			htp.header(2, 'Membre');
			htp.print('<a class="btn btn-primary" href="afft_membre" >Consulter la liste des membres</a>');
			htp.print('<a class="btn btn-primary" href="ui_frmadd_membre" >Inscrire un membre</a>');
			htp.print('<a class="btn btn-primary" href="ui_frmedit_avoir" >Validation inscription membre</a>');
			htp.print('<a class="btn btn-primary" href="ui_frmedit_attribuer" >Edition statut</a>');
			htp.print('<a class="btn btn-primary" href="ui_frmedit_autoriser" >Edition droits utilisation</a>');
			htp.hr;
			htp.header(2, 'Société');
			htp.print('<a class="btn btn-primary" href="ui_frmedit_societe" >Modifier sa société</a>');
			htp.hr;
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
END;