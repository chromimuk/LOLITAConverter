CREATE OR REPLACE
PROCEDURE admin_expert
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
			htp.header(1,'Administration expert LOLITA');
			htp.br;
			htp.header(2, 'Sujet');
			htp.print('<a class="btn btn-primary" href="afft_sujet" >Edition statut sujet</a>');
			htp.hr;
			htp.header(2, 'Soci�t�');
			htp.print('<a class="btn btn-primary" href="ui_frmadd_societe" >Inscription soci�t�</a>');
			htp.hr;
			htp.header(2, 'Domaine');
			htp.print('<a class="btn btn-primary" href="ui_frmadd_domaine" >Cr�ation domaine</a>');
			htp.print('<a class="btn btn-primary" href="afft_domaine" >Edition domaine</a>');
			htp.print('<a class="btn btn-primary" href="afft_se_specialiser" >Edition sp�cialisation</a>');
			htp.hr;
			htp.header(2, 'Cat�gorie');
			htp.print('<a class="btn btn-primary" href="ui_frmadd_categorie" >Cr�ation cat�gorie</a>');
			htp.print('<a class="btn btn-primary" href="ui_frmadd_posseder" >Attribution cat�gorie � un domaine</a>');
			htp.hr;
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
END;
