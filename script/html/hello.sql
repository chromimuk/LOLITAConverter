CREATE OR REPLACE
PROCEDURE hello
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	cookie_lolita owa_cookie.cookie;
	user_id  integer;
BEGIN

BEGIN
    cookie_lolita := owa_cookie.get('LOLITA');
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('LOLITA');
			htp.print('<link href="https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css" rel="stylesheet">');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
			htp.header(1,'LOLITA');
			if (cookie_lolita.num_vals > 0)
			then 
			    user_id  := cookie_lolita.vals(1);
			    htp.header(2, 'Bonjour ' || user_id);
			end if;
			htp.br;
			htp.print('<a class="btn btn-success" href="ui_frmadd_membre" >Inscription</a>');
			htp.print('<a class="btn btn-primary" href="login" >Connexion</a>');
			htp.hr;
			htp.print('<a class="btn btn-info" href="admin" >Administration</a>');
			htp.print('<a class="btn btn-danger" href="admin_expert" >Administration expert</a>');
			htp.br;
			htp.br;
			htp.print('<div class="jumbotron">');
			htp.print('<a href="hello">');
			htp.print('<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />'
			htp.print('</a>');
			htp.print('</div>');
			htp.br;
			htp.header(2,'Nos domaines de compétences');
			htp.print('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
			htp.br;
			htp.print('<a class="btn btn-primary" href="afft_domaine" >Consulter nos domaines de compétences</a>');
			htp.hr;
			htp.header(2,'Nos experts');
			htp.print('Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.');
			htp.br;
			htp.print('<a class="btn btn-primary" href="afft_membre_from_typmembre?vtypmembre=E" >En savoir plus sur nos experts</a>');
			htp.hr;
			htp.header(2,'Questions/réponses');
			htp.print('<a class="btn btn-primary" href="afft_sujet_from_libtypesujet?vlibtypesujet=FQ" >Consulter la FAQ</a>');
			htp.print('<a class="btn btn-primary" href="afft_sujet_from_libtypesujet?vlibtypesujet=QR" >Consulter la liste des sujets</a>');
			htp.print('<a class="btn btn-primary" href="ui_frmadd_sujet" >Creer un nouveau sujet</a>');
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
	EXCEPTION
		WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/
