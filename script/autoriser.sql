-- PROCEDURES CONCERNANT LA TABLE AUTORISER

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_autoriser
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		A.CODE, C.LIBELLE, M.PREMEMBRE, M.NOMMEMBRE, M.NUMMEMBRE, D.LIBDOMAINE
	FROM 
		CODELOLITA C
		Inner Join AUTORISER A 
		ON C.CODE = A.CODE
		Inner Join MEMBRE M
		ON A.NUMMEMBRE = M.NUMMEMBRE
		Inner Join DOMAINE D
		ON A.NUMDOMAINE = D.NUMDOMAINE;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table autoriser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Droits sur les domaines');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Membre');
	htp.tableHeader('Code du droit');
	htp.tableHeader('Libellé');
	htp.tableHeader('Domaine');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.premembre || ' ' || rec.nommembre);
	htp.tableData(rec.code);
	htp.tableData(rec.libelle);
	htp.tableData(rec.libdomaine);
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
CREATE OR REPLACE PROCEDURE pa_add_autoriser
	(
		vnummembre in number,
		vcode in varchar2,
		vnumdomaine in number
	)
IS
BEGIN
	INSERT INTO autoriser VALUES
	(
		vnummembre,
		'DRO',
		vcode,
		vnumdomaine
	);
COMMIT;
END;
/


--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel à la requête pa_add_autoriser
CREATE OR REPLACE PROCEDURE ui_execadd_autoriser
	(
		vnummembre in number,
		vcode in varchar2,
		vnumdomaine in number
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
	htp.title('Insertion autoriser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	header(user_id, user_name, user_type, user_right);
	if(user_id >= 0)
	then
		pa_add_autoriser(vnummembre,vcode,vnumdomaine);
		htp.header(1, '<a href="hello">');
		htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
		htp.header(1, '</a>');
		htp.hr;
		htp.header(2, 'Ajout effectue dans la table autoriser');
		htp.print('<a class="btn btn-primary" href="afft_autoriser" >Voir la liste complete</a>');
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
------- Validation redirige vers ui_execadd_autoriser
CREATE OR REPLACE PROCEDURE ui_frmadd_autoriser
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
	CURSOR lstCod IS
		SELECT
		C.CODE
		FROM
		CODELOLITA C
		WHERE
		C.NATURE='DRO'
		ORDER BY
		C.CODE
		;
	CURSOR lstDom IS
		SELECT
		D.NUMDOMAINE, D.LIBDOMAINE
		FROM
		DOMAINE D
		ORDER BY
		D.LIBDOMAINE
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
	htp.title('Insertion autoriser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	header(user_id, user_name, user_type, user_right);
	if(user_id >= 0)
	then
		htp.header(1, 'Ajout élément dans la table autoriser');
		htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_autoriser', 'GET');
		htp.print('<table class="table">');
		htp.tableRowOpen;
		htp.print('<td>Code</td>');
		htp.print('<td>');
		htp.formSelectOpen('vcode', '');
		FOR rec IN lstCod LOOP
			htp.formSelectOption(rec.code);
		END LOOP;
		htp.formSelectClose;
		htp.print('</td>');
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.print('<td>Membre</td>');
		htp.print('<td>');
		htp.formSelectOpen('vnummembre', '');
		FOR rec IN lstMem LOOP
			htp.formSelectOption(rec.premembre || ' ' || rec.nommembre,
			cattributes=>'value=' || rec.nummembre);
		END LOOP;
		htp.formSelectClose;
		htp.print('</td>');
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.print('<td>Numéro du domaine</td>');
		htp.print('<td>');
		htp.formSelectOpen('vnumdomaine', '');
		FOR rec IN lstDom LOOP
			htp.formSelectOption(rec.libdomaine,
			cattributes=>'value=' || rec.numdomaine);
		END LOOP;
		htp.formSelectClose;
		htp.print('</td>');
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

--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_autoriser
	(
		vnummembre in number,
		vcode in varchar2,
		vnumdomaine in number
	)
IS
BEGIN
	UPDATE 
		AUTORISER
	SET
		code = vcode,
	WHERE 
		nature = 'DRO'
	AND
		nummembre = vnummembre
	AND
		numdomaine = vnumdomaine;
	COMMIT;
END;
/

--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_autoriser
CREATE OR REPLACE
PROCEDURE ui_execedit_autoriser
	(
		vnummembre in number,
		vcode in varchar2,
		vnumdomaine in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table AUTORISER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_autoriser(vnummembre,vcode,vnumdomaine);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table AUTORISER');
	htp.print('<a class="btn btn-primary" href="afft_autoriser" >>Consulter la liste AUTORISER</a>');
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
------- Validation redirige vers ui_execedit_autoriser
CREATE OR REPLACE PROCEDURE ui_frmedit_autoriser
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition autoriser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition autoriser');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_autoriser', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vcode');
	htp.tableData(htf.formText('vcode', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumdomaine');
	htp.tableData(htf.formText('vnumdomaine', 2));
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
PROCEDURE pa_del_autoriser
	(
		vnummembre in number
	)
IS
BEGIN
	DELETE FROM 
		AUTORISER
	WHERE 
		nummembre = vnummembre;
	COMMIT;
END;
/


--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_autoriser
CREATE OR REPLACE
PROCEDURE ui_execdel_autoriser
	(
		vnummembre in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table AUTORISER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_autoriser(vnummembre);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table AUTORISER');
	htp.print('<a class="btn btn-primary" href="afft_autoriser" >>Consulter la liste AUTORISER</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/
