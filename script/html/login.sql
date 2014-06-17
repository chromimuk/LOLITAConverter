-- does not work :(
CREATE OR REPLACE PROCEDURE pa_login
	(
		vemail in varchar2,
		vmdp in varchar2
	)
IS
BEGIN
	SELECT
		*
	FROM
		MEMBRE
	WHERE
		MAIMEMBRE = vemail
	AND
		MDPMEMBRE = vmdp;
COMMIT;
END;
/





CREATE OR REPLACE
PROCEDURE ui_execlogin
	(
		vemail in varchar2,
		vmdp in varchar2
	)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vnum number(5);
BEGIN
	SELECT NUMMEMBRE INTO vnum FROM MEMBRE WHERE MAIMEMBRE = vemail;
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('Connexion');
			htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
			pa_login(vemail,vmdp);
			htp.header(1, 'LOLITA');
			htp.hr;
			htp.header(2, 'Connexion réussie');
			owa_cookie.send(name=>'LOLITA', value=>vnum); 
			htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
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
			htp.formOpen(owa_util.get_owa_service_path || 'ui_execlogin', 'POST');
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
			htp.print('<a class="btn btn-info" href="mdp_oubli" >Mot de passe oublié ?</a>');
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
END;
