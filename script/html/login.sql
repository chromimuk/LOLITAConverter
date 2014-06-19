CREATE OR REPLACE PROCEDURE pa_login
	(
		vemail in varchar2,
		vmdp in varchar2
	)
IS
  vnummembre number(5);
BEGIN
	SELECT
		NUMMEMBRE into vnummembre
	FROM
		MEMBRE
	WHERE
		MAIMEMBRE = vemail
	AND
		MDPMEMBRE = vmdp;
		
	set_cookie(vnummembre);
	ui_execlogin;
	
	EXCEPTION
	    WHEN NO_DATA_FOUND THEN  
	    login;
	    
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE logout
IS
BEGIN
   	owa_util.mime_header('text/html', FALSE);

	owa_cookie.remove('user', NULL);
	hello;
	
	owa_util.http_header_close;
END;
/

CREATE OR REPLACE PROCEDURE set_cookie
	(
		vid in number
	)
IS
BEGIN
   owa_util.mime_header('text/html', FALSE);
   
   -- Create a cookie
   owa_cookie.send(
      name=>'user',
      value=>vid,
      expires=> sysdate+1,
      path=>'/');
      
   owa_util.http_header_close;
 
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/


CREATE OR REPLACE
PROCEDURE ui_execlogin
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('Connexion');
			htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
			htp.header(1, '<a href="hello">');
			htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
			htp.header(1, '</a>');
			htp.hr;
			htp.header(2, 'Connexion réussie');
			htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
END;
/



CREATE OR REPLACE
PROCEDURE login
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
			htp.header(1,'LOLITA');
			htp.br;
			htp.header(2, 'Connexion');
			htp.formOpen(owa_util.get_owa_service_path || 'pa_login', 'POST');
				htp.print('<table class="table">');
					htp.tableRowOpen;
						htp.tableData('Email');
						htp.tableData(htf.formText('vemail', 50));
						htp.tableRowClose;
					htp.tableRowOpen;
						htp.tableData('Mot de passe');
						htp.tableData(htf.formText('vmdp', 50));
					htp.tableRowClose;
				htp.tableClose;
				htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
			htp.formClose;
			htp.br;
			htp.br;
			htp.print('<a class="btn btn-info" href="mdp_oubli" >Mot de passe oublié ?</a>');
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
END;
/
