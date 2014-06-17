CREATE OR REPLACE PROCEDURE pa_change_mdp
	(
		vemail in varchar2
	)
IS
	vnummembre number(5);
BEGIN
	SELECT nummembre INTO vnummembre FROM membre WHERE MAIMEMBRE = vemail;
	UPDATE 
		AVOIR
	SET
		DATECODE = TO_CHAR(SYSDATE),
		MOTIF = null,
		NATURE = 'STA',
		CODE = 'S05'
	WHERE 
		NUMMEMBRE = vnummembre;
	COMMIT;
COMMIT;
END;
/





CREATE OR REPLACE
PROCEDURE ui_execlogin
	(
		vemail in varchar2
	)
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
			pa_change_mdp(vemail);
			htp.header(1, 'LOLITA');
			htp.hr;
			htp.header(2, 'Mot de passe ré-initialisé');
			htp.print('Un email vous a été envoyé');
			htp.br;
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
PROCEDURE mdp_oubli
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
			htp.header(2, 'Mot de passe oublié');
			htp.formOpen(owa_util.get_owa_service_path || 'ui_execlogin', 'POST');
				htp.print('<table class="table">');
					htp.tableRowOpen;
						htp.tableData('Email');
						htp.tableData(htf.formText('vemail', 50));
						htp.tableRowClose;
				htp.tableClose;
				htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
			htp.formClose;
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
END;
