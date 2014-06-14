create or replace
PROCEDURE hello
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
	htp.header(1,'LOLITA '  || htf.anchor('admin', '<small>- Administration</small>'));
	htp.br;
	htp.print('<div class="jumbotron">');
	htp.print('<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.print('</div>');
	htp.br;
  htp.print('<a class="btn btn-primary" href="ui_frmadd_membre" >Inscription</a>');
  htp.hr;
	htp.print('<a class="btn btn-primary" href="afft_membre" >Voir la liste des membres</a>');
	htp.hr;
	htp.print('<a class="btn btn-primary" href="afft_sujet" >Voir la liste des sujets</a>');
	htp.print('<a class="btn btn-primary" href="ui_frmadd_sujet" >Creer un sujet</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;