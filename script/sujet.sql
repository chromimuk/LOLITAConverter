-- PROCEDURES CONCERNANT LA TABLE SUJET

--1 Affichage des donn�es

--1.1 Affichage de toutes les donn�es de la table
CREATE OR REPLACE
PROCEDURE afft_sujet
IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
	CURSOR lst
	IS 
	SELECT 
		  S.NUMSUJET
		 ,S.TITSUJET
		 ,S.STASUJET
		 ,S.LIBVISIBILITE
		 ,S.LIBTYPESUJET
		 ,S.DTESUJET
		 ,D.LIBDOMAINE
		 ,MC.PREMEMBRE
		 ,MC.NOMMEMBRE
		 ,ME.PREMEMBRE
		 ,ME.NOMMEMBRE
	FROM 
		SUJET S Inner Join MEMBRE MC
		On S.NUMMEMBRE = MC.NUMMEMBRE
		Inner Join MEMBRE ME
		On S.NUMMEMBRE_HER_MEMBRE = ME.NUMMEMBRE
		Inner Join DOMAINE D
		ON S.NUMDOMAINE = D.NUMDOMAINE;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste sujet');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Num�ro');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.numsujet);
	htp.tableData(rec.nomdomaine);
	-- à voir comment accéder quand y a plusieurs colonnes du meme nom
	htp.tableData(rec.nummembre);
	htp.tableData(rec.nummembre_her_membre);
	htp.tableData(rec.titsujet);
	htp.tableData(rec.stasujet);
	htp.tableData(rec.libvisibilite);
	htp.tableData(rec.libtypesujet);
	htp.tableData(rec.dtesujet);
	htp.tableData(
		htf.anchor('ui_frmedit_sujet?vnumsujet=' || rec.numsujet, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_sujet?vnumsujet=' || rec.numsujet, 'Supprimer')
	);
	htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/

--1.2 Affichage des elements d'un sujet selon son ID
CREATE OR REPLACE PROCEDURE afft_sujet_from_numsujet
	(vnumsujet varchar2 default 'test') IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vtitsujet varchar(50);
CURSOR lst IS 
	SELECT 
		MS.NUMMESSAGE, S.TITSUJET, ME.NOMMEMBRE, ME.PREMEMBRE, ME.PHOMEMBRE, MS.TEXMESSAGE, MS.DTEMESSAGE, MS.NSUMESSAGE
	FROM 
		SUJET S
		Inner Join MESSAGE MS
		On MS.NUMSUJET = S.NUMSUJET
		Inner Join MEMBRE ME
		On ME.NUMMEMBRE = MS.NUMMEMBRE
	WHERE
		S.NUMSUJET = vnumsujet
	ORDER BY
		MS.NSUMESSAGE
	;
BEGIN
	Select TITSUJET Into vtitsujet From SUJET Where NUMSUJET = vnumsujet;
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Table sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Sujet : ' || vtitsujet);
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableHeader('Membre');
	htp.tableHeader('Message');
	htp.tableRowClose;
	FOR rec IN lst loop
		htp.tableRowOpen;
		htp.tableData
		(
			'<img width="100%" src="https://dl.dropboxusercontent.com/u/21548623/' || rec.phomembre || '" />'
			|| '<br/>' || rec.premembre || ' ' || rec.nommembre 
			|| '<br/>Le ' || rec.dtemessage
			, cattributes => 'width=130px;'
		);
		htp.tableData(rec.texmessage);
		htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('<a class="btn btn-primary" href="ui_frmadd_message_sujet?vnumsujet=' || vnumsujet || '" >Repondre</a>');
	htp.hr;
	htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/




--2 Insertion

--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_sujet
CREATE OR REPLACE PROCEDURE ui_frmadd_sujet
IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout �l�ment dans la table sujet');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_sujet', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnumsujet');
	htp.tableData(htf.formText('vnumsujet', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumdomaine');
	htp.tableData(htf.formText('vnumdomaine', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnummembre_her_membre');
	htp.tableData(htf.formText('vnummembre_her_membre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vtitsujet');
	htp.tableData(htf.formText('vtitsujet', 80));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vstasujet');
	htp.tableData(htf.formText('vstasujet', 1));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vlibvisibilite');
	htp.tableData(htf.formText('vlibvisibilite', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vlibtypesujet');
	htp.tableData(htf.formText('vlibtypesujet', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vdtesujet');
	htp.tableData(htf.formText('vdtesujet', 10));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel � la requ�te pa_add_sujet
CREATE OR REPLACE PROCEDURE ui_execadd_sujet
	(
		vnumsujet in number,
		vnumdomaine in number,
		vnummembre in number,
		vnummembre_her_membre in number,
		vtitsujet in varchar2,
		vstasujet in number,
		vlibvisibilite in varchar2,
		vlibtypesujet in varchar2,
		vdtesujet in date
	)

IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_sujet(vnumsujet,vnumdomaine,vnummembre,vnummembre_her_membre,vtitsujet,vstasujet,vlibvisibilite,vlibtypesujet,vdtesujet);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table sujet');
	htp.print('<a class="btn btn-primary" href="afft_sujet" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.1 Requ�te SQL
CREATE OR REPLACE PROCEDURE pa_add_sujet
	(
		vnumsujet in number,
		vnumdomaine in number,
		vnummembre in number,
		vnummembre_her_membre in number,
		vtitsujet in varchar2,
		vstasujet in number,
		vlibvisibilite in varchar2,
		vlibtypesujet in varchar2,
		vdtesujet in date
	)
IS
BEGIN
	INSERT INTO sujet VALUES
	(
		vnumsujet,
		vnumdomaine,
		vnummembre,
		vnummembre_her_membre,
		vtitsujet,
		vstasujet,
		vlibvisibilite,
		vlibtypesujet,
		vdtesujet
	);
COMMIT;
END;
/


--3 Edition

--3.1.3 Formulaire d'�dition
------- Validation redirige vers ui_execedit_sujet
CREATE OR REPLACE PROCEDURE ui_frmadd_sujet
IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition sujet');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_sujet', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnumsujet');
	htp.tableData(htf.formText('vnumsujet', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumdomaine');
	htp.tableData(htf.formText('vnumdomaine', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnummembre_her_membre');
	htp.tableData(htf.formText('vnummembre_her_membre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vtitsujet');
	htp.tableData(htf.formText('vtitsujet', 80));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vstasujet');
	htp.tableData(htf.formText('vstasujet', 1));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vlibvisibilite');
	htp.tableData(htf.formText('vlibvisibilite', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vlibtypesujet');
	htp.tableData(htf.formText('vlibtypesujet', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vdtesujet');
	htp.tableData(htf.formText('vdtesujet', 10));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--3.1.1 Requ�te SQL
CREATE OR REPLACE
PROCEDURE pa_edit_sujet
	(
		vnumsujet in number,
		vnumdomaine in number,
		vnummembre in number,
		vnummembre_her_membre in number,
		vtitsujet in varchar2,
		vstasujet in number,
		vlibvisibilite in varchar2,
		vlibtypesujet in varchar2,
		vdtesujet in date
	)
IS
BEGIN
	UPDATE 
		SUJET
	SET
		numdomaine = vnumdomaine,
		nummembre = vnummembre,
		nummembre_her_membre = vnummembre_her_membre,
		titsujet = vtitsujet,
		stasujet = vstasujet,
		libvisibilite = vlibvisibilite,
		libtypesujet = vlibtypesujet,
		dtesujet = vdtesujet
	WHERE 
		numsujet = vnumsujet
	COMMIT;
END;
/


--3.1.2 Page de validation d'�dition
-------Appel � la requ�te pa_edit_sujet
CREATE OR REPLACE
PROCEDURE ui_execedit_sujet
	(
		vnumsujet in number,
		vnumdomaine in number,
		vnummembre in number,
		vnummembre_her_membre in number,
		vtitsujet in varchar2,
		vstasujet in number,
		vlibvisibilite in varchar2,
		vlibtypesujet in varchar2,
		vdtesujet in date
	)
IS
rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table SUJET');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_sujet(vnumsujet,vnumdomaine,vnummembre,vnummembre_her_membre,vtitsujet,vstasujet,vlibvisibilite,vlibtypesujet,vdtesujet);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Edition effectu�e dans la table SUJET');
	htp.print('<a class="btn btn-primary" href="afft_sujet" >>Consulter la liste SUJET</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/






--3.2.1 Requ�te SQL
CREATE OR REPLACE
PROCEDURE pa_edit_sujet_stasujet
	(
		vnumsujet in number,
		vstasujet in number
	)
IS
BEGIN
	UPDATE 
		SUJET
	SET
		stasujet = vstasujet,
	WHERE 
		numsujet = vnumsujet
	COMMIT;
END;
/



--3.2.2 Page de validation d'�dition du statut de sujet
-------Appel � la requ�te pa_edit_sujet_stasujet
CREATE OR REPLACE
PROCEDURE ui_execedit_sujet_stasujet_stasujet
	(
		vnumsujet in number,
		vstasujet in number
	)
IS
rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table SUJET');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_sujet_stasujet(vnumsujet,vstasujet);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Edition effectu�e dans la table SUJET');
	htp.print('<a class="btn btn-primary" href="afft_sujet" >>Consulter la liste SUJET</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/



--3.2.3 Formulaire d'�dition du statut du sujet
------- Validation redirige vers ui_execedit_sujet_stasujet
CREATE OR REPLACE PROCEDURE ui_frmadd_sujet_stasujet
IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition sujet');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_sujet_stasujet', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnumsujet');
	htp.tableData(htf.formText('vnumsujet', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vstasujet');
	htp.tableData(htf.formText('vstasujet', 1));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--4 Suppression

--4.1.2 Page de validation de suppression
-------Appel � la requ�te pa_del_sujet
CREATE OR REPLACE
PROCEDURE ui_execdel_sujet
	(
		vnumsujet in number
	)
IS
rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table SUJET');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_sujet(vnumsujet)
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Suppression �l�ment dans la table SUJET');
	htp.print('<a class="btn btn-primary" href="afft_sujet" >>Consulter la liste SUJET</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--4.1.1 Requ�te SQL
CREATE OR REPLACE
PROCEDURE pa_del_sujet
	(
		vnumsujet in number
	)
IS
BEGIN
	DELETE FROM 
		SUJET
	WHERE 
		numsujet = vnumsujet
	COMMIT;
END;
/
