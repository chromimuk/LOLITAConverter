-- PROCEDURES CONCERNANT LA TABLE LANGUE

--1 Affichage des données
--1.1 Affichage de toutes les données de la table

--2 Insertion
--2.1 Insertion simple, via un formulaire
--2.1.1 Requête SQL
--2.1.2 Page de validation d'insertion, avec gestion des erreurs
--2.1.3 Formulaire d'insertion

--3 Edition
--3.1 Edition via ID
--3.1.1 Requête SQL
--3.1.2 Page de validation d'édition
--3.1.3 Formulaire d'édition

--4 Suppression
--4.1 Suppression via ID
--4.1.1 Requête SQL
--4.1.2 Page de validation de suppression



--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_langue
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS
	SELECT
		*
	FROM
		LANGUE;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('Affichage table LANGUE');
			htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
				htp.header(1, 'LOLITA');
				htp.hr;
				htp.header(2, 'Liste langue');
				htp.print('<table class="table">');
					htp.tableRowOpen(cattributes => 'class=active');
						htp.tableHeader('N°');
						htp.tableHeader('Libellé');
						htp.tableHeader('Actions');
					htp.tableRowClose;
					FOR rec IN lst LOOP
						htp.tableRowOpen;
							htp.tableData(rec.numlangue);
							htp.tableData(rec.liblangue);
							htp.tableData(
								htf.anchor('ui_frmedit_langue?vnumlangue=' || rec.numlangue, 'Modifier')
								|| ' ou ' ||
								htf.anchor('ui_execdel_langue?vnumlangue=' || rec.numlangue, 'Supprimer')
							);
						htp.tableRowClose;
					END LOOP;
				htp.tableClose;
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
END;




--2 Insertion

--2.1 Insertion simple, via un formulaire

--2.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_add_langue
(
	vliblangue in varchar2
)
IS
BEGIN
	INSERT INTO langue VALUES
	(
		seq_langue.nextval,
		vliblangue
	);
	COMMIT;
END;
/

--2.1.2 Page de validation d'insertion, avec gestion des erreurs
------- Appel à la requête pa_add_langue(vnumlangue,vliblangue);
CREATE OR REPLACE
PROCEDURE ui_execadd_langue
(
	vliblangue in varchar2
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('Insertion table LANGUE');
			htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
			pa_add_langue(vliblangue);
			htp.header(1, 'LOLITA');
			htp.hr;
			htp.header(2, 'Ajout effectue dans la table LANGUE');
			htp.print('<a class="btn btn-primary" href="afft_langue" >Consulter la liste LANGUE</a>');
			htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_langue
CREATE OR REPLACE
PROCEDURE ui_frmadd_langue
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('Insertion table LANGUE');
			htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
				htp.header(1, 'Insertion élément dans la table LANGUE');
				htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_langue', 'POST');
					htp.print('<table class="table">');
						htp.tableRowOpen;
							htp.tableData('vliblangue');
							htp.tableData(htf.formText('vliblangue', 30));
						htp.tableRowClose;
					htp.tableClose;
					htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
				htp.formClose;
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
END;
/


--3 Edition

--3.1 Edition via ID

--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_langue
(
	vnumlangue in number,
	vliblangue in varchar2
)
IS
BEGIN
	UPDATE langue SET
		LIBLANGUE = vliblangue
	WHERE
		NUMLANGUE = vnumlangue
	;
	COMMIT;
END;
/


--3.1.2 Page de validation d'édition
------- Appel à la requête pa_edit_langue(vnumlangue,vliblangue);
CREATE OR REPLACE
PROCEDURE ui_execedit_langue
(
	vnumlangue in number,
	vliblangue in varchar2
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('Edition langue');
			htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
				pa_edit_langue(vnumlangue,vliblangue);
				htp.header(1, 'LOLITA');
				htp.hr;
				htp.header(2, 'Edition effectuée dans la table LANGUE');
				htp.print('<a class="btn btn-primary" href="afft_langue" >Consulter la liste LANGUE</a>');
				htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
	EXCEPTION
		WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--3.1.3 Formulaire d'édition
------- Validation redirige vers ui_execedit_langue
CREATE OR REPLACE
PROCEDURE ui_frmedit_langue
(
	vnumlangue in number
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vliblangue varchar2(30);
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('Edition langue');
			htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
				htp.header(1, 'Edition langue');
				htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_langue', 'POST');
					htp.print('<table class="table">');
						htp.tableRowOpen;
							htp.tableData('Numéro de la langue');
							htp.tableData(htf.formText('vnumlangue', 2));
						htp.tableRowClose;
						htp.tableRowOpen;
							htp.tableData('Libellé de la langue');
							htp.tableData(htf.formText('vliblangue', 30));
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

--4.1 Suppression via ID

--4.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_del_langue
(
	vnumlangue in number
)
IS
BEGIN
	DELETE FROM
		LANGUE
	WHERE
		NUMLANGUE = vnumlangue;
	COMMIT;
END;
/


--4.1.2 Page de validation de suppression
------- Appel à la requête pa_del_langue(vnumlangue,vliblangue);
CREATE OR REPLACE
PROCEDURE ui_execdel_langue
(
	vnumlangue in number
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('Suppression table LANGUE');
			htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
				pa_del_langue(vnumlangue);
				htp.header(1, 'LOLITA');
				htp.hr;
				htp.header(2, 'Suppression élément dans la table LANGUE');
				htp.print('<a class="btn btn-primary" href="afft_langue" >Consulter la liste LANGUE</a>');
				htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
			htp.print('</div>');
		htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/
