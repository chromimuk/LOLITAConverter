-- PROCEDURES CONCERNANT LA TABLE SOCIETE

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_societe
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		 *
	FROM 
		SOCIETE;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table societe');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Liste societe');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Numéro');
	htp.tableHeader('Type');
	htp.tableHeader('Nom');
	htp.tableHeader('Description');
	htp.tableHeader('Date inscription');
	htp.tableHeader('Mail');
	htp.tableHeader('Domaine internet');
	htp.tableHeader('Numéro de voie');
	htp.tableHeader('Nom de la voie');
	htp.tableHeader('Code postal');
	htp.tableHeader('Ville');
	htp.tableHeader('Pays');
	htp.tableHeader('Téléphone');
	htp.tableHeader('Logo');
	htp.tableHeader('Wallpaper');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.numsociete);
	htp.tableData(rec.typsociete);
	htp.tableData(rec.nomsociete);
	htp.tableData(rec.dscsociete);
	htp.tableData(rec.dtesociete);
	htp.tableData(rec.maisociete);
	htp.tableData(rec.domsociete);
	htp.tableData(rec.numadrsociete);
	htp.tableData(rec.nomadrsociete);
	htp.tableData(rec.copadrsociete);
	htp.tableData(rec.viladrsociete);
	htp.tableData(rec.payadrsociete);
	htp.tableData(rec.telsociete);
	htp.tableData(rec.logsociete);
	htp.tableData(rec.fonsociete);
	htp.tableData(
		htf.anchor('ui_frmedit_societe?vnumsociete=' || rec.numsociete, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_societe?vnumsociete=' || rec.numsociete, 'Supprimer')
	);
	htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/



--1.2 Affichage du profil d'une société
CREATE OR REPLACE 
PROCEDURE afft_societe_from_numsociete
	(vnumsociete number default 2)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vnomsociete varchar2(30);
	vlogsociete clob;
	Cursor lst is 
		SELECT 
			*
		FROM 
			SOCIETE
		WHERE
			NUMSOCIETE = vnumsociete;
BEGIN
	Select NOMSOCIETE, LOGSOCIETE 
	Into vnomsociete, vlogsociete 
	From SOCIETE 
	Where NUMSOCIETE = vnumsociete;
	htp.htmlOpen;
	htp.headopen;
	htp.title('Profil societe');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headclose;
	htp.print('<div class="container">');
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Profil de la societe ' || vnomsociete);
	htp.br;
	htp.print('<img src="https://dl.dropboxusercontent.com/u/21548623/' || vlogsociete || '" />');
	htp.br;
	htp.br;
	htp.print('<table class="table">');
	htp.tableRowOpen;
		htp.tableHeader('Type');
		htp.tableHeader('Description');
		htp.tableHeader('Date crea');
		htp.tableHeader('Mail contact');
		htp.tableHeader('Adresse');
		htp.tableHeader('Tel');
	htp.tableRowClose;
	for rec in lst loop
		htp.tableRowOpen;
			htp.tableData(rec.typsociete);
			htp.tableData(rec.dscsociete);
			htp.tableData(rec.dtesociete);
			htp.tableData(rec.maisociete);
			htp.tableData(rec.numadrsociete || ' ' || rec.nomadrsociete || ' ' || rec.copadrsociete || '<br/>' || rec.viladrsociete || ' ' || rec.payadrsociete);
			htp.tableData(rec.telsociete);
		htp.tableRowClose;
	end loop;
	htp.tableClose;
	htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
End;
/


--2 Insertion

--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_societe
CREATE OR REPLACE 
PROCEDURE ui_frmadd_societe
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion societe');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table societe');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_societe', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
		htp.print('<td>Type</td>');
		htp.print('<td>');
		htp.formSelectOpen('vtypsociete', '');
			htp.formSelectOption('C');
			htp.formSelectOption('E');
		htp.formSelectClose;
		htp.print('</td>');
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Nom');
	htp.tableData(htf.formText('vnomsociete', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Description');
	htp.tableData(htf.formText('vdscsociete', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Mail société');
	htp.tableData(htf.formText('vmaisociete', 80));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Domaine internet');
	htp.tableData(htf.formText('vdomsociete', 20));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Numéro de la voie');
	htp.tableData(htf.formText('vnumadrsociete', 10));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Nom de la voie');
	htp.tableData(htf.formText('vnomadrsociete', 40));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Code postal');
	htp.tableData(htf.formText('vcopadrsociete', 8));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Ville');
	htp.tableData(htf.formText('vviladrsociete', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Pays');
	htp.tableData(htf.formText('vpayadrsociete', 20));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Téléphone');
	htp.tableData(htf.formText('vtelsociete', 15));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Logo');
	htp.tableData(htf.formText('vlogsociete', 100));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Wallpaper');
	htp.tableData(htf.formText('vfonsociete', 100));
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
-------Appel à la requête pa_add_societe
CREATE OR REPLACE PROCEDURE ui_execadd_societe
	(
		vtypsociete in varchar2,
		vnomsociete in varchar2,
		vdscsociete in clob,
		vmaisociete in varchar2,
		vdomsociete in varchar2,
		vnumadrsociete in varchar2,
		vnomadrsociete in varchar2,
		vcopadrsociete in varchar2,
		vviladrsociete in varchar2,
		vpayadrsociete in varchar2,
		vtelsociete in varchar2,
		vlogsociete in varchar2,
		vfonsociete in varchar2
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion societe');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_societe(vtypsociete,vnomsociete,vdscsociete,vmaisociete,vdomsociete,vnumadrsociete,vnomadrsociete,vcopadrsociete,vviladrsociete,vpayadrsociete,vtelsociete,vlogsociete,vfonsociete);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table societe');
	htp.print('<a class="btn btn-primary" href="afft_societe" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.1 Requête SQL
CREATE OR REPLACE PROCEDURE pa_add_societe
	(
		vtypsociete in varchar2,
		vnomsociete in varchar2,
		vdscsociete in clob,
		vmaisociete in varchar2,
		vdomsociete in varchar2,
		vnumadrsociete in varchar2,
		vnomadrsociete in varchar2,
		vcopadrsociete in varchar2,
		vviladrsociete in varchar2,
		vpayadrsociete in varchar2,
		vtelsociete in varchar2,
		vlogsociete in varchar2,
		vfonsociete in varchar2
	)
IS
BEGIN
	INSERT INTO societe VALUES
	(
		seq_societe.nextval,
		vtypsociete,
		vnomsociete,
		vdscsociete,
		TO_CHAR(SYSDATE),
		vmaisociete,
		vdomsociete,
		vnumadrsociete,
		vnomadrsociete,
		vcopadrsociete,
		vviladrsociete,
		vpayadrsociete,
		vtelsociete,
		vlogsociete,
		vfonsociete
	);
COMMIT;
END;
/


--3 Edition


--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_societe
	(
		vnumsociete in number,
		vtypsociete in varchar2,
		vnomsociete in varchar2,
		vdscsociete in clob,
		vmaisociete in varchar2,
		vdomsociete in varchar2,
		vnumadrsociete in varchar2,
		vnomadrsociete in varchar2,
		vcopadrsociete in varchar2,
		vviladrsociete in varchar2,
		vpayadrsociete in varchar2,
		vtelsociete in varchar2,
		vlogsociete in varchar2,
		vfonsociete in varchar2
	)
IS
BEGIN
	UPDATE 
		SOCIETE
	SET
		typsociete = vtypsociete,
		nomsociete = vnomsociete,
		dscsociete = vdscsociete,
		dtesociete = TO_CHAR(SYSDATE),
		maisociete = vmaisociete,
		domsociete = vdomsociete,
		numadrsociete = vnumadrsociete,
		nomadrsociete = vnomadrsociete,
		copadrsociete = vcopadrsociete,
		viladrsociete = vviladrsociete,
		payadrsociete = vpayadrsociete,
		telsociete = vtelsociete,
		logsociete = vlogsociete,
		fonsociete = vfonsociete
	WHERE 
		numsociete = vnumsociete;
	COMMIT;
END;
/



--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_societe
CREATE OR REPLACE
PROCEDURE ui_execedit_societe
	(
		vnumsociete in number,
		vtypsociete in varchar2,
		vnomsociete in varchar2,
		vdscsociete in clob,
		vmaisociete in varchar2,
		vdomsociete in varchar2,
		vnumadrsociete in varchar2,
		vnomadrsociete in varchar2,
		vcopadrsociete in varchar2,
		vviladrsociete in varchar2,
		vpayadrsociete in varchar2,
		vtelsociete in varchar2,
		vlogsociete in varchar2,
		vfonsociete in varchar2
	)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table SOCIETE');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_societe(vnumsociete,vtypsociete,vnomsociete,vdscsociete,vmaisociete,vdomsociete,vnumadrsociete,vnomadrsociete,vcopadrsociete,vviladrsociete,vpayadrsociete,vtelsociete,vlogsociete,vfonsociete);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table SOCIETE');
	htp.print('<a class="btn btn-primary" href="afft_societe" >>Consulter la liste SOCIETE</a>');
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
------- Validation redirige vers ui_execedit_societe
CREATE OR REPLACE PROCEDURE ui_frmedit_societe
(
	vnumsociete integer
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lstMem IS
		SELECT
		M.NUMMEMBRE, M.NOMMEMBRE, M.PREMEMBRE
		FROM
		MEMBRE M
		ORDER BY
		M.NUMMEMBRE
		;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition societe');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition societe');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_societe', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.print('<input type="hidden" name="vnumsociete" value="' || vnumsociete || '"/>');
	htp.tableRowOpen;
		htp.print('<td>Type</td>');
		htp.print('<td>');
		htp.formSelectOpen('vtypsociete', '');
			htp.formSelectOption('C');
			htp.formSelectOption('E');
		htp.formSelectClose;
		htp.print('</td>');
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Nom');
	htp.tableData(htf.formText('vnomsociete', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Description');
	htp.tableData(htf.formText('vdscsociete', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Mail');
	htp.tableData(htf.formText('vmaisociete', 80));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Domaine internet');
	htp.tableData(htf.formText('vdomsociete', 20));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Numéro de la voie');
	htp.tableData(htf.formText('vnumadrsociete', 10));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Nom de la voie');
	htp.tableData(htf.formText('vnomadrsociete', 40));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Code postal');
	htp.tableData(htf.formText('vcopadrsociete', 8));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Ville');
	htp.tableData(htf.formText('vviladrsociete', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Pays');
	htp.tableData(htf.formText('vpayadrsociete', 20));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Téléphone');
	htp.tableData(htf.formText('vtelsociete', 15));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Logo');
	htp.tableData(htf.formText('vlogsociete', 100));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Wallpaper');
	htp.tableData(htf.formText('vfonsociete', 100));
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

--4.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_del_societe
	(
		vnumsociete in number
	)
IS
BEGIN
	DELETE FROM 
		SOCIETE
	WHERE 
		numsociete = vnumsociete;
	COMMIT;
END;
/


--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_societe
CREATE OR REPLACE
PROCEDURE ui_execdel_societe
	(
		vnumsociete in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table SOCIETE');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_societe(vnumsociete);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table SOCIETE');
	htp.print('<a class="btn btn-primary" href="afft_societe" >>Consulter la liste SOCIETE</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/
