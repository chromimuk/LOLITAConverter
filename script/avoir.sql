-- PROCEDURES CONCERNANT LA TABLE AVOIR

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_avoir
IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
	CURSOR lst
	IS 
	SELECT 
		 A.DATECODE, A.MOTIF, A.NATURE, A.CODE, M.PREMEMBRE, M.NOMMEMBRE
	FROM 
		AVOIR A Inner Join MEMBRE M
		ON A.NUMMEMBRE = M.NUMMEMBRE;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table avoir');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste avoir');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Numéro');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.premembre || ' ' || rec.nommembre);
	htp.tableData(rec.datecode);
	htp.tableData(rec.motif);
	htp.tableData(rec.nature);
	htp.tableData(rec.code);
	htp.tableData(
		htf.anchor('ui_frmedit_avoir?vnummembre=' || rec.nummembre, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_avoir?vnummembre=' || rec.nummembre, 'Supprimer')
	);
	htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--2 Insertion

--2.1.1 Requête SQL
CREATE OR REPLACE PROCEDURE pa_add_avoir
	(
		vnummembre in number,
		vdatecode in date,
		vmotif in clob,
		vnature in varchar2,
		vcode in varchar2
	)
IS
BEGIN
	INSERT INTO avoir VALUES
	(
		vnummembre,
		vdatecode,
		vmotif,
		vnature,
		vcode
	);
COMMIT;
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_avoir
CREATE OR REPLACE PROCEDURE ui_frmadd_avoir
IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion avoir');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table avoir');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_avoir', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vdatecode');
	htp.tableData(htf.formText('vdatecode', 10));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vmotif');
	htp.tableData(htf.formText('vmotif', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnature');
	htp.tableData(htf.formText('vnature', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vcode');
	htp.tableData(htf.formText('vcode', 3));
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
-------Appel à la requête pa_add_avoir
CREATE OR REPLACE PROCEDURE ui_execadd_avoir
	(
		vnummembre in number,
		vdatecode in date,
		vmotif in clob,
		vnature in varchar2,
		vcode in varchar2
	)

IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion avoir');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_avoir(vnummembre,vdatecode,vmotif,vnature,vcode);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table avoir');
	htp.print('<a class="btn btn-primary" href="afft_avoir" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--3 Edition

--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_avoir
	(
		vnummembre in number,
		vdatecode in date,
		vmotif in clob,
		vnature in varchar2,
		vcode in varchar2
	)
IS
BEGIN
	UPDATE 
		AVOIR
	SET
		datecode = vdatecode,
		motif = vmotif,
		nature = vnature,
		code = vcode
	WHERE 
		nummembre = vnummembre
	COMMIT;
END;
/


--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_avoir
CREATE OR REPLACE
PROCEDURE ui_execedit_avoir
	(
		vnummembre in number,
		vdatecode in date,
		vmotif in clob,
		vnature in varchar2,
		vcode in varchar2
	)
IS
rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table AVOIR');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_avoir(vnummembre,vdatecode,vmotif,vnature,vcode);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table AVOIR');
	htp.print('<a class="btn btn-primary" href="afft_avoir" >>Consulter la liste AVOIR</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--3.1.3 Formulaire d'édition
------- Validation redirige vers ui_execedit_avoir
CREATE OR REPLACE PROCEDURE ui_frmedit_avoir
IS
	rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition avoir');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition avoir');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_avoir', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vdatecode');
	htp.tableData(htf.formText('vdatecode', 10));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vmotif');
	htp.tableData(htf.formText('vmotif', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnature');
	htp.tableData(htf.formText('vnature', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vcode');
	htp.tableData(htf.formText('vcode', 3));
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
-------Appel à la requête pa_del_avoir
CREATE OR REPLACE
PROCEDURE ui_execdel_avoir
	(
		vnummembre in number
	)
IS
rep_css varchar2(255) := https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table AVOIR');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_avoir(vnummembre)
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table AVOIR');
	htp.print('<a class="btn btn-primary" href="afft_avoir" >>Consulter la liste AVOIR</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
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
PROCEDURE pa_del_avoir
	(
		vnummembre in number
	)
IS
BEGIN
	DELETE FROM 
		AVOIR
	WHERE 
		nummembre = vnummembre
	COMMIT;
END;
/

