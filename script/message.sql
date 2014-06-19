-- PROCEDURES CONCERNANT LA TABLE MESSAGE

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_message
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		MS.NUMMESSAGE, S.TITSUJET, ME.NOMMEMBRE, MS.TEXMESSAGE, MS.DTEMESSAGE, MS.NSUMESSAGE
	FROM 
		SUJET S
		Inner Join MESSAGE MS
		On MS.NUMSUJET = S.NUMSUJET
		Inner Join MEMBRE ME
		On ME.NUMMEMBRE = MS.NUMMEMBRE
	ORDER BY
		MS.NUMMESSAGE
	;
	user_id number(5);
	user_name varchar2(80);	
	user_type varchar2(2);
	user_right varchar2(4);
BEGIN
	get_info_user(user_id, user_name, user_type);
	get_info_user_right(user_right);

	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	
	htp.title('Affichage table message');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	
		
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);
	
	if (user_id >= 0)
	then 

		htp.header(1, '<a href="hello">');
		htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
		htp.header(1, '</a>');
		htp.hr;
		htp.header(2, 'Liste message');
		htp.print('<table class="table">');
		htp.tableRowOpen(cattributes => 'class=active');
			htp.tableHeader('Dans le sujet');
			htp.tableHeader('Ecrit par');
			htp.tableHeader('Message');
			htp.tableHeader('Date');
			htp.tableHeader('N° dans sujet');
			htp.tableHeader('Actions');
		htp.tableRowClose;
		FOR rec IN lst LOOP
		htp.tableRowOpen;
			htp.tableData(rec.titsujet);
			htp.tableData(rec.nommembre);
			htp.tableData(rec.texmessage);
			htp.tableData(rec.dtemessage);
			htp.tableData(rec.nsumessage);
			htp.tableData(
				htf.anchor('ui_frmedit_message?vnummessage=' || rec.nummessage, 'Modifier')
				|| ' ou ' ||
				htf.anchor('ui_execdel_message?vnummessage=' || rec.nummessage, 'Supprimer')
			);
		htp.tableRowClose;
		END LOOP;
		htp.tableClose;
		htp.print('</div>');
	else
		htp.br;
		htp.br;
		htp.header(2, 'Non connecté !');
		htp.br;
		htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	end if;
	
	htp.bodyClose;
	htp.htmlClose;
END;
/


--2 Insertion





--2.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_add_message
	(
		vnumsujet in number,
		vnummembre in number,
		vtexmessage in clob,
		vnsumessage in number
	)
IS
BEGIN
	INSERT INTO message VALUES
	(
		seq_message.nextval,
		vnumsujet,
		vnummembre,
		vtexmessage,
		TO_CHAR(SYSDATE),
		vnsumessage
	);
COMMIT;
END;
/


--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel à la requête pa_add_message
CREATE OR REPLACE
PROCEDURE ui_execadd_message
	(
		vnumsujet in number,
		vnummembre in number,
		vtexmessage in clob,
		vnsumessage in number
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	
	user_id number(5);
	user_name varchar2(80);	
	user_type varchar2(2);
	user_right varchar2(4);
BEGIN
	get_info_user(user_id, user_name, user_type);
	get_info_user_right(user_right);
	
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion message');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');	
	header(user_id, user_name, user_type, user_right);
	if (user_id >= 0)
	then 
		pa_add_message(vnumsujet,vnummembre,vtexmessage,vnsumessage);
		htp.header(1, '<a href="hello">');
		htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
		htp.header(1, '</a>');
		htp.hr;
		htp.header(2, 'Ajout effectue dans la table message');
		htp.print('<a class="btn btn-primary" href="afft_sujet_from_numsujet?vnumsujet=' || vnumsujet || '" >Retour au sujet</a>');
	else
		htp.br;
		htp.br;
		htp.header(2, 'Non connecté !');
		htp.br;
		htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	end if;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_message
CREATE OR REPLACE 
PROCEDURE ui_frmadd_message
	(vnumsujet number)
IS
	vcount number(3);
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	
	user_id number(5);
	user_name varchar2(80);	
	user_type varchar2(2);
	user_right varchar2(4);
BEGIN
	get_info_user(user_id, user_name, user_type);
	get_info_user_right(user_right);
	
	Select Count(*) Into vcount From SUJET Where NUMSUJET = vnumsujet;
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion message');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	header(user_id, user_name, user_type, user_right);
	if (user_id >= 0)
	then 
		htp.header(1, 'Ajout élément dans la table message');
		htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_message', 'POST');
		htp.print('<table class="table">');
		htp.print('<input type="hidden" name="vnumsujet" value="' || vnumsujet || '"/>');
		htp.print('<input type="hidden" name="vnsumessage" value="' || vcount || '"/>');
		htp.tableRowOpen;
		htp.tableData('Numéro du membre');
		htp.tableData(htf.formText('vnummembre', 5));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Texte du message');
		htp.tableData(htf.formText('vtexmessage', 1000));
		htp.tableRowClose;
		htp.tableClose;
		htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
		htp.formClose;
	else
		htp.br;
		htp.br;
		htp.header(2, 'Non connecté !');
		htp.br;
		htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	end if;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--3 Edition

--3.1.3 Formulaire d'édition
------- Validation redirige vers ui_execedit_message
CREATE OR REPLACE PROCEDURE ui_frmedit_message
(
	vnummessage integer
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	
	user_id number(5);
	user_name varchar2(80);	
	user_type varchar2(2);
	user_right varchar2(4);
BEGIN
	get_info_user(user_id, user_name, user_type);
	get_info_user_right(user_right);
	
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition message');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	header(user_id, user_name, user_type, user_right);
	if (user_id >= 0)
	then 
		htp.header(1, 'Edition message');
		htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_message', 'POST');
		htp.print('<table class="table">');
		htp.print('<input type="hidden" name="vnummessage" value="' || vnummessage || '"/>');
		htp.tableRowOpen;
		htp.tableData('Numéro du sujet');
		htp.tableData(htf.formText('vnumsujet', 5));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Numéro du membre');
		htp.tableData(htf.formText('vnummembre', 5));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Texte du message');
		htp.tableData(htf.formText('vtexmessage', 1000));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Numéro du message dans le sujet');
		htp.tableData(htf.formText('vnsumessage', 4));
		htp.tableRowClose;
		htp.tableClose;
		htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
		htp.formClose;
	else
		htp.br;
		htp.br;
		htp.header(2, 'Non connecté !');
		htp.br;
		htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	end if;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_message
CREATE OR REPLACE
PROCEDURE ui_execedit_message
	(
		vnummessage in number,
		vnumsujet in number,
		vnummembre in number,
		vtexmessage in clob,
		vnsumessage in number
	)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	
	user_id number(5);
	user_name varchar2(80);	
	user_type varchar2(2);
	user_right varchar2(4);
BEGIN
	get_info_user(user_id, user_name, user_type);
	get_info_user_right(user_right);
	
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table MESSAGE');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	header(user_id, user_name, user_type, user_right);
	if (user_id >= 0)
	then 
		pa_edit_message(vnummessage,vnumsujet,vnummembre,vtexmessage,vnsumessage);
		htp.header(1, '<a href="hello">');
		htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
		htp.header(1, '</a>');
		htp.hr;
		htp.header(2, 'Edition effectuée dans la table MESSAGE');
		htp.print('<a class="btn btn-primary" href="afft_message" >>Consulter la liste MESSAGE</a>');
		htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	else
		htp.br;
		htp.br;
		htp.header(2, 'Non connecté !');
		htp.br;
		htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	end if;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_message
	(
		vnummessage in number,
		vnumsujet in number,
		vnummembre in number,
		vtexmessage in clob,
		vnsumessage in number
	)
IS
BEGIN
	UPDATE 
		MESSAGE
	SET
		numsujet = vnumsujet,
		nummembre = vnummembre,
		texmessage = vtexmessage,
		nsumessage = vnsumessage
	WHERE 
		nummessage = vnummessage;
	COMMIT;
END;
/


--4 Suppression

--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_message
CREATE OR REPLACE
PROCEDURE ui_execdel_message
	(
		vnummessage in number
	)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	
	user_id number(5);
	user_name varchar2(80);	
	user_type varchar2(2);
	user_right varchar2(4);
BEGIN
	get_info_user(user_id, user_name, user_type);
	get_info_user_right(user_right);
	
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table MESSAGE');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	header(user_id, user_name, user_type, user_right);
	if (user_id >= 0)
	then 
		pa_del_message(vnummessage);
		htp.header(1, '<a href="hello">');
		htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
		htp.header(1, '</a>');
		htp.hr;
		htp.header(2, 'Suppression élément dans la table MESSAGE');
		htp.print('<a class="btn btn-primary" href="afft_message" >>Consulter la liste MESSAGE</a>');
		htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	else
		htp.br;
		htp.br;
		htp.header(2, 'Non connecté !');
		htp.br;
		htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	end if;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--4.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_del_message
	(
		vnummessage in number
	)
IS
BEGIN
	DELETE FROM 
		MESSAGE
	WHERE 
		nummessage = vnummessage;
	COMMIT;
END;
/

