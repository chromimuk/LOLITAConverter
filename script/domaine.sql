-- PROCEDURES CONCERNANT LA TABLE DOMAINE

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_domaine
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vdompere varchar2(30);
	CURSOR lst
	IS 
	SELECT 
		 *
	FROM 
		DOMAINE;
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
	htp.title('Affichage table domaine');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	header(user_id, user_name, user_type, user_right);
	if(user_id >= 0)
	then
	
		--htp.header(1, '<a href="hello">');
		--htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
		--htp.header(1, '</a>');
		htp.hr;
		htp.header(2, 'Liste domaine');
		htp.print('<table class="table">');
		htp.tableRowOpen(cattributes => 'class=active');
		htp.tableHeader('Numéro');
		htp.tableHeader('Numéro domaine père');
		htp.tableHeader('Numéro de société');
		htp.tableHeader('Libellé domaine');
		htp.tableHeader('Abréviation domaine');
		htp.tableHeader('Date domaine');
		htp.tableHeader('Date modification domaine');
		htp.tableHeader('Description');
		htp.tableHeader('Logo domaine');
		htp.tableHeader('Actions');
		htp.tableRowClose;
		FOR rec IN lst LOOP
			BEGIN
			Select LIBDOMAINE Into vdompere From DOMAINE Where NUMDOMAINE = rec.numdomaine_appartenir;
			EXCEPTION
			      WHEN NO_DATA_FOUND THEN
			        vdompere := NULL;
			END;
			htp.tableRowOpen;
				htp.tableData(rec.numdomaine);
				htp.tableData(vdompere);
				htp.tableData(rec.numsociete);
				htp.tableData(rec.libdomaine);
				htp.tableData(rec.abrdomaine);
				htp.tableData(rec.dtedomaine);
				htp.tableData(rec.dmodomaine);
				htp.tableData(rec.dscdomaine);
				htp.tableData(rec.logdomaine);
				htp.tableData(
					htf.anchor('ui_frmedit_domaine?vnumdomaine=' || rec.numdomaine, 'Modifier')
					|| ' ou ' ||
					htf.anchor('ui_execdel_domaine?vnumdomaine=' || rec.numdomaine, 'Supprimer')
				);
			htp.tableRowClose;
		END LOOP;
		htp.tableClose;
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


CREATE OR REPLACE
PROCEDURE afft_domaine_user
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vdompere varchar2(30);
	CURSOR lst
	IS 
	SELECT 
		 *
	FROM 
		DOMAINE;
		
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
	htp.title('Affichage table domaine');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;

	htp.print('<div class="container">');
	header(user_id, user_name, user_type, user_right);
	if(user_id >= 0)
	then	
		
		--htp.header(1, '<a href="hello">');
		--htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
		--htp.header(1, '</a>');
		htp.hr;
		htp.header(2, 'Liste de nos domaines de compétences');
		htp.print('<table class="table">');
		htp.tableRowOpen(cattributes => 'class=active');
		htp.tableHeader('Numéro');
		htp.tableHeader('Domaine père');
		htp.tableHeader('Numéro de société');
		htp.tableHeader('Libellé domaine');
		htp.tableHeader('Abréviation domaine');
		htp.tableHeader('Description');
		htp.tableRowClose;
		FOR rec IN lst LOOP
			BEGIN
			Select LIBDOMAINE Into vdompere From DOMAINE Where NUMDOMAINE = rec.numdomaine_appartenir;
			EXCEPTION
			      WHEN NO_DATA_FOUND THEN
			        vdompere := NULL;
			END;
			htp.tableRowOpen;
				htp.tableData(rec.numdomaine);
				htp.tableData(vdompere);
				htp.tableData(rec.numsociete);
				htp.tableData(rec.libdomaine);
				htp.tableData(rec.abrdomaine);
				htp.tableData(rec.dscdomaine);
			htp.tableRowClose;
		END LOOP;
		htp.tableClose;
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






--2 Insertion


--2.1.1 Requête SQL
CREATE OR REPLACE PROCEDURE pa_add_domaine
	(
		vnumdomaine_appartenir in number,
		vnumsociete in number,
		vlibdomaine in varchar2,
		vabrdomaine in varchar2,
		vdscdomaine in clob,
		vlogdomaine in varchar2
	)
IS
BEGIN
	INSERT INTO domaine VALUES
	(
		seq_domaine.nextval,
		vnumdomaine_appartenir,
		vnumsociete,
		vlibdomaine,
		vabrdomaine,
		TO_CHAR(SYSDATE),
		TO_CHAR(SYSDATE),
		vdscdomaine,
		vlogdomaine
	);
COMMIT;
END;
/


--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel à la requête pa_add_domaine
CREATE OR REPLACE PROCEDURE ui_execadd_domaine
	(
		vnumdomaine_appartenir in number,
		vnumsociete in number,
		vlibdomaine in varchar2,
		vabrdomaine in varchar2,
		vdscdomaine in clob,
		vlogdomaine in varchar2
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion domaine');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_domaine(vnumdomaine_appartenir,vnumsociete,vlibdomaine,vabrdomaine,vdscdomaine,vlogdomaine);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table domaine');
	htp.print('<a class="btn btn-primary" href="afft_domaine" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_domaine
CREATE OR REPLACE
PROCEDURE ui_frmadd_domaine
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lstSoc
	IS 
	SELECT 
		S.NOMSOCIETE, S.NUMSOCIETE
	FROM 
		SOCIETE S;
	CURSOR lstDom
	IS 
	SELECT 
		D.LIBDOMAINE, D.NUMDOMAINE
	FROM 
		DOMAINE D;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion domaine');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table domaine');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_domaine', 'GET');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.print('<td>Domaine père</td>');
	htp.print('<td>');
	htp.formSelectOpen('vnumdomaine_appartenir', '');
	FOR rec IN lstDom LOOP
		htp.formSelectOption(
		rec.libdomaine,
		cattributes=>'value=' || rec.numdomaine
		);
	END LOOP;
	htp.formSelectClose;
	htp.print('</td>');
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.print('<td>Societe</td>');
	htp.print('<td>');
	htp.formSelectOpen('vnumsociete', '');
	FOR rec IN lstSoc LOOP
		htp.formSelectOption(
		rec.nomsociete,
		cattributes=>'value=' || rec.numsociete
		);
	END LOOP;
	htp.formSelectClose;
	htp.print('</td>');
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Libellé');
	htp.tableData(htf.formText('vlibdomaine', 50));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Abréviation');
	htp.tableData(htf.formText('vabrdomaine', 32));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Description');
	htp.tableData(htf.formText('vdscdomaine', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Logo');
	htp.tableData(htf.formText('vlogdomaine', 100));
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

--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_domaine
	(
		vnumdomaine in number,
		vnumdomaine_appartenir in number,
		vnumsociete in number,
		vlibdomaine in varchar2,
		vabrdomaine in varchar2,
		vdscdomaine in clob,
		vlogdomaine in varchar2
	)
IS
BEGIN
	UPDATE 
		DOMAINE
	SET
		numdomaine_appartenir = vnumdomaine_appartenir,
		numsociete = vnumsociete,
		libdomaine = vlibdomaine,
		abrdomaine = vabrdomaine,
		dmodomaine = TO_DATE(SYSDATE),
		dscdomaine = vdscdomaine,
		logdomaine = vlogdomaine
	WHERE 
		numdomaine = vnumdomaine;
	COMMIT;
END;
/


--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_domaine
CREATE OR REPLACE
PROCEDURE ui_execedit_domaine
	(
		vnumdomaine in number,
		vnumdomaine_appartenir in number,
		vnumsociete in number,
		vlibdomaine in varchar2,
		vabrdomaine in varchar2,
		vdscdomaine in clob,
		vlogdomaine in varchar2
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table DOMAINE');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_domaine(vnumdomaine,vnumdomaine_appartenir,vnumsociete,vlibdomaine,vabrdomaine,vdscdomaine,vlogdomaine);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table DOMAINE');
	htp.print('<a class="btn btn-primary" href="afft_domaine" >>Consulter la liste DOMAINE</a>');
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
------- Validation redirige vers ui_execedit_domaine
CREATE OR REPLACE PROCEDURE ui_frmedit_domaine
(
	vnumdomaine integer
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lstSoc
	IS 
	SELECT 
		S.NOMSOCIETE, S.NUMSOCIETE
	FROM 
		SOCIETE S;
	CURSOR lstDom
	IS 
	SELECT 
		D.LIBDOMAINE, D.NUMDOMAINE
	FROM 
		DOMAINE D;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition domaine');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition domaine');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_domaine', 'POST');
	htp.print('<table class="table">');
	htp.print('<input type="hidden" name="vnumdomaine" value="' || vnumdomaine || '"/>');
	htp.tableRowOpen;
	htp.print('<td>Domaine père</td>');
	htp.print('<td>');
	htp.formSelectOpen('vnumdomaine_appartenir', '');
	FOR rec IN lstDom LOOP
		htp.formSelectOption(
		rec.libdomaine,
		cattributes=>'value=' || rec.numdomaine
		);
	END LOOP;
	htp.formSelectClose;
	htp.print('</td>');
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.print('<td>Societe</td>');
	htp.print('<td>');
	htp.formSelectOpen('vnumsociete', '');
	FOR rec IN lstSoc LOOP
		htp.formSelectOption(
		rec.nomsociete,
		cattributes=>'value=' || rec.numsociete
		);
	END LOOP;
	htp.formSelectClose;
	htp.print('</td>');
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Libellé');
	htp.tableData(htf.formText('vlibdomaine', 50));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Abréviation');
	htp.tableData(htf.formText('vabrdomaine', 32));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Description');
	htp.tableData(htf.formText('vdscdomaine', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Logo');
	htp.tableData(htf.formText('vlogdomaine', 100));
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
PROCEDURE pa_del_domaine
	(
		vnumdomaine in number
	)
IS
BEGIN
	DELETE FROM 
		DOMAINE
	WHERE 
		numdomaine = vnumdomaine;
	COMMIT;
END;
/


--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_domaine
CREATE OR REPLACE
PROCEDURE ui_execdel_domaine
	(
		vnumdomaine in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table DOMAINE');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_domaine(vnumdomaine);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table DOMAINE');
	htp.print('<a class="btn btn-primary" href="afft_domaine" >>Consulter la liste DOMAINE</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/

