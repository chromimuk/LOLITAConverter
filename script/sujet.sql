-- PROCEDURES CONCERNANT LA TABLE SUJET

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_sujet
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vpreclient varchar(30);
	vnomclient varchar(30);
	vpreexpert varchar(30);
	vnomexpert varchar(30);
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
		 ,S.NUMMEMBRE
		 ,S.NUMMEMBRE_HER_MEMBRE
	FROM 
		SUJET S Inner Join DOMAINE D
		ON S.NUMDOMAINE = D.NUMDOMAINE
	ORDER BY
		S.DTESUJET DESC
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
	htp.title('Affichage table sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 

		htp.hr;
		htp.header(2, 'Liste sujet');
		htp.print('<table class="table">');
		htp.tableRowOpen(cattributes => 'class=active');
			htp.tableHeader('N°');
			htp.tableHeader('Titre');
			htp.tableHeader('Domaine');
			htp.tableHeader('Client');
			htp.tableHeader('Expert');
			htp.tableHeader('Visibilité');
			htp.tableHeader('Type');
			htp.tableHeader('Date');
			htp.tableHeader('Actions');
		htp.tableRowClose;
		FOR rec IN lst LOOP
			SELECT PREMEMBRE, NOMMEMBRE 
			INTO vpreclient, vnomclient
			FROM membre 
			WHERE nummembre = rec.nummembre;
			SELECT PREMEMBRE, NOMMEMBRE 
			INTO vpreexpert, vnomexpert
			FROM membre 
			WHERE nummembre = rec.nummembre_her_membre; 		
			IF (rec.stasujet = 0) THEN
				htp.tableRowOpen(cattributes => 'class=warning');
			ELSE
				htp.tableRowOpen;
			END IF;
				htp.tableData(rec.numsujet);
				htp.tableData(
					htf.anchor(
						'afft_sujet_from_numsujet?vnumsujet=' || rec.numsujet,
						rec.titsujet
					)
				);
				htp.tableData(rec.libdomaine);
				htp.tableData(
					htf.anchor(
						'afft_membre_from_nummembre?vnummembre=' || rec.nummembre,
						vpreclient || ' ' || vnomclient
					)
				);
				htp.tableData(
					htf.anchor(
						'afft_membre_from_nummembre?vnummembre=' || rec.nummembre_her_membre,
						vpreexpert || ' ' || vnomexpert
					)
				);
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





--1.2 Affichage des elements d'un sujet selon son ID
CREATE OR REPLACE PROCEDURE afft_sujet_from_numsujet
	(vnumsujet number) IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vtitsujet varchar2(50);
	vstasujet varchar(1);
	CURSOR lst IS 
	SELECT 
		MS.NUMMESSAGE, S.TITSUJET, ME.NOMMEMBRE, ME.PREMEMBRE,
		ME.PHOMEMBRE, MS.TEXMESSAGE, MS.DTEMESSAGE, MS.NSUMESSAGE
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
	user_id number(5);
	user_name varchar2(80);
	user_type varchar2(2);
	user_right varchar2(4);
BEGIN
	get_info_user(user_id, user_name, user_type);
    	get_info_user_right(user_right);

	Select TITSUJET, STASUJET Into vtitsujet, vstasujet From SUJET Where NUMSUJET = vnumsujet;
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Table sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 

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
		
		if (vstasujet = 1) then
			htp.print('<a class="btn btn-primary" href="ui_frmadd_message?vnumsujet=' || vnumsujet || '" >Repondre</a>');
		end if;
		
		htp.hr;
		htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
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


--1.3 Affichage des elements d'un sujet selon son type
CREATE OR REPLACE
PROCEDURE afft_sujet_from_libtypesujet
	(vlibtypesujet varchar default 'QR')
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vpreclient varchar2(30);
	vnomclient varchar2(30);
	vpreexpert varchar2(30);
	vnomexpert varchar2(30);
	CURSOR lst
	IS
	SELECT
		  S.NUMSUJET
		 ,S.TITSUJET
		 ,S.STASUJET
		 ,S.LIBVISIBILITE
		 ,S.DTESUJET
		 ,D.LIBDOMAINE
		 ,S.NUMMEMBRE
		 ,S.NUMMEMBRE_HER_MEMBRE
	FROM
		SUJET S Inner Join DOMAINE D
		ON S.NUMDOMAINE = D.NUMDOMAINE
	WHERE
		S.LIBTYPESUJET = vlibtypesujet
	ORDER BY
		S.DTESUJET DESC
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
	htp.title('Affichage table sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 
		htp.hr;
		IF (vlibtypesujet = 'QR') THEN
			htp.header(2, 'Questions/r‚ponses');
		ELSIF (vlibtypesujet = 'FQ') THEN
			htp.header(2, 'Foire aux questions');
		END IF;
		htp.print('<table class="table">');
		htp.tableRowOpen(cattributes => 'class=active');
			htp.tableHeader('Nø');
			htp.tableHeader('Titre');
			htp.tableHeader('Domaine');
			IF (vlibtypesujet = 'QR') THEN
				htp.tableHeader('Client');
			END IF;
			htp.tableHeader('Expert');
			htp.tableHeader('Visibilit‚');
			htp.tableHeader('Date');
			htp.tableHeader('Actions');
		htp.tableRowClose;
		FOR rec IN lst LOOP
			SELECT PREMEMBRE, NOMMEMBRE
			INTO vpreclient, vnomclient
			FROM membre
			WHERE nummembre = rec.nummembre;
			SELECT PREMEMBRE, NOMMEMBRE
			INTO vpreexpert, vnomexpert
			FROM membre
			WHERE nummembre = rec.nummembre_her_membre;
			IF (rec.stasujet = 0) THEN
				htp.tableRowOpen(cattributes => 'class=warning');
			ELSE
				htp.tableRowOpen;
			END IF;
				htp.tableData(rec.numsujet);
				htp.tableData(
					htf.anchor(
						'afft_sujet_from_numsujet?vnumsujet=' || rec.numsujet,
						rec.titsujet
					)
				);
				htp.tableData(rec.libdomaine);
				IF (vlibtypesujet = 'QR') THEN
				htp.tableData(
					htf.anchor(
						'afft_membre_from_nummembre?vnummembre=' || rec.nummembre,
						vpreclient || ' ' || vnomclient
					)
				);
				END IF;
				htp.tableData(
					htf.anchor(
						'afft_membre_from_nummembre?vnummembre=' || rec.nummembre_her_membre,
						vpreexpert || ' ' || vnomexpert
					)
				);
				htp.tableData(rec.libvisibilite);
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



--1.4 Affichage des sujets pour users
CREATE OR REPLACE
PROCEDURE afft_sujet_from_type_user
	(vlibtypesujet varchar default 'QR')
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	vpreclient varchar2(30);
	vnomclient varchar2(30);
	vpreexpert varchar2(30);
	vnomexpert varchar2(30);
	CURSOR lst
	IS
	SELECT
		  S.NUMSUJET
		 ,S.TITSUJET
		 ,S.STASUJET
		 ,S.LIBVISIBILITE
		 ,S.DTESUJET
		 ,D.LIBDOMAINE
		 ,S.NUMMEMBRE
		 ,S.NUMMEMBRE_HER_MEMBRE
	FROM
		SUJET S Inner Join DOMAINE D
		ON S.NUMDOMAINE = D.NUMDOMAINE
	WHERE
		S.LIBTYPESUJET = vlibtypesujet
	ORDER BY
		S.DTESUJET DESC
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
	htp.title('Affichage table sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 
	
		htp.hr;
		IF (vlibtypesujet = 'QR') THEN
			htp.header(2, 'Questions/reponses');
		ELSIF (vlibtypesujet = 'FQ') THEN
			htp.header(2, 'Foire aux questions');
		END IF;
		htp.print('<table class="table">');
		htp.tableRowOpen(cattributes => 'class=active');
			htp.tableHeader('Nø');
			htp.tableHeader('Titre');
			htp.tableHeader('Domaine');
			IF (vlibtypesujet = 'QR') THEN
				htp.tableHeader('Client');
			END IF;
			htp.tableHeader('Expert');
			htp.tableHeader('Date');
		htp.tableRowClose;
		FOR rec IN lst LOOP
			SELECT PREMEMBRE, NOMMEMBRE
			INTO vpreclient, vnomclient
			FROM membre
			WHERE nummembre = rec.nummembre;
			
			SELECT PREMEMBRE, NOMMEMBRE
			INTO vpreexpert, vnomexpert
			FROM membre
			WHERE nummembre = rec.nummembre_her_membre;
			
			IF (rec.stasujet = 0) THEN
				htp.tableRowOpen(cattributes => 'class=warning');
			ELSE
				htp.tableRowOpen;
			END IF;
			htp.tableData(rec.numsujet);
			htp.tableData(
				htf.anchor(
					'afft_sujet_from_numsujet?vnumsujet=' || rec.numsujet,
					rec.titsujet
				)
			);
			htp.tableData(rec.libdomaine);
			IF (vlibtypesujet = 'QR') THEN
			htp.tableData(
				htf.anchor(
					'afft_membre_from_nummembre?vnummembre=' || rec.nummembre,
					vpreclient || ' ' || vnomclient
				)
			);
			END IF;
			htp.tableData(
				htf.anchor(
					'afft_membre_from_nummembre?vnummembre=' || rec.nummembre_her_membre,
					vpreexpert || ' ' || vnomexpert
				)
			);
			htp.tableData(rec.dtesujet);
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


--2.1.1 Requ�te SQL
CREATE OR REPLACE PROCEDURE pa_add_sujet
	(
		vnumdomaine in number,
		vnummembre in number,
		vnummembre_her_membre in number,
		vtitsujet in varchar2,
		vlibvisibilite in varchar2,
		vlibtypesujet in varchar2
	)
IS
BEGIN
	INSERT INTO sujet VALUES
	(
		seq_sujet.nextval,
		vnumdomaine,
		vnummembre,
		vnummembre_her_membre,
		vtitsujet,
		0,
		vlibvisibilite,
		vlibtypesujet,
		TO_CHAR(SYSDATE)
	);
COMMIT;
END;
/

--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel � la requ�te pa_add_sujet
CREATE OR REPLACE PROCEDURE ui_execadd_sujet
	(
		vnumdomaine in number,
		vnummembre in number,
		vnummembre_her_membre in number,
		vtitsujet in varchar2,
		vlibvisibilite in varchar2,
		vlibtypesujet in varchar2
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
	htp.title('Insertion sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');

	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 
		pa_add_sujet(vnumdomaine,vnummembre,vnummembre_her_membre,vtitsujet,vlibvisibilite,vlibtypesujet);
	
		htp.hr;
		htp.header(2, 'Ajout effectue dans la table sujet');
		htp.print('<a class="btn btn-primary" href="afft_sujet" >Voir la liste complete</a>');
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
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_sujet
CREATE OR REPLACE
PROCEDURE ui_frmadd_sujet
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lstDom IS
	SELECT D.NUMDOMAINE, D.LIBDOMAINE
	FROM DOMAINE D
	ORDER BY 1;
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
	htp.title('Insertion sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

		if (user_id >= 0)
		then 
		
		htp.header(1, 'Ajout �l�ment dans la table sujet');
		htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_sujet', 'POST');
			htp.print('<table class="table">');
			htp.tableRowOpen;
			htp.print('<td>Domaine</td>');
			htp.print('<td>');
			htp.formSelectOpen('vnumdomaine', '');
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
			htp.tableData('Numéro de membre');
			htp.tableData(htf.formText('vnummembre', 5));
			htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableData('Numéro du membre qui prend en charge');
			htp.tableData(htf.formText('vnummembre_her_membre', 5));
			htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableData('Titre du sujet');
			htp.tableData(htf.formText('vtitsujet', 80));
			htp.tableRowClose;
			htp.tableRowOpen;
			htp.print('<td>Visibilité</td>');
			htp.print('<td>');
			htp.formSelectOpen('vlibvisibilite', '');
				htp.formSelectOption('PR');
				htp.formSelectOption('PU');
				htp.formSelectOption('EN');
			htp.formSelectClose;
			htp.print('</td>');
			htp.tableRowClose;
			htp.tableRowOpen;
			htp.print('<td>Type du sujet</td>');
			htp.print('<td>');
			htp.formSelectOpen('vlibtypesujet', '');
				htp.formSelectOption('QR');
				htp.formSelectOption('FQ');
			htp.formSelectClose;
			htp.print('</td>');
			htp.tableRowClose;
			htp.tableClose;
			htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
		htp.formClose;
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



--3 Edition

--3.1.3 Formulaire d'�dition
------- Validation redirige vers ui_execedit_sujet
CREATE OR REPLACE
PROCEDURE ui_frmedit_sujet
	(vnumsujet in number)
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
	htp.title('Edition sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 
		
		htp.header(1, 'Edition sujet');
		htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_sujet', 'POST');
		htp.print('<table class="table">');
		htp.print('<input type="hidden" name="vnumsujet" value="' || vnumsujet || '"/>');
		htp.tableRowOpen;
		htp.tableData('Numéro du domaine');
		htp.tableData(htf.formText('vnumdomaine', 2));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Titre');
		htp.tableData(htf.formText('vtitsujet', 80));
		htp.tableRowClose;
		htp.tableRowOpen;
			htp.print('<td>Statut</td>');
			htp.print('<td>');
			htp.formSelectOpen('vstasujet', '');
				htp.formSelectOption(0);
				htp.formSelectOption(1);
			htp.formSelectClose;
			htp.print('</td>');
		htp.tableRowClose;
		htp.tableRowOpen;
			htp.print('<td>Visibilité</td>');
			htp.print('<td>');
			htp.formSelectOpen('vlibvisibilite', '');
				htp.formSelectOption('PR');
				htp.formSelectOption('PU');
				htp.formSelectOption('EN');
			htp.formSelectClose;
			htp.print('</td>');
		htp.tableRowClose;
		htp.tableRowOpen;
			htp.print('<td>Type du sujet</td>');
			htp.print('<td>');
			htp.formSelectOpen('vlibtypesujet', '');
				htp.formSelectOption('QR');
				htp.formSelectOption('FQ');
			htp.formSelectClose;
			htp.print('</td>');
		htp.tableRowClose;
		htp.tableClose;
		htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
		htp.formClose;
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
		vlibtypesujet in varchar2
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
		libtypesujet = vlibtypesujet
	WHERE 
		numsujet = vnumsujet;
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
		vlibtypesujet in varchar2
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
	htp.title('Edition table SUJET');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 
	
		pa_edit_sujet(vnumsujet,vnumdomaine,vnummembre,vnummembre_her_membre,vtitsujet,vstasujet,vlibvisibilite,vlibtypesujet);

		htp.hr;
		htp.header(2, 'Edition effectu�e dans la table SUJET');
		htp.print('<a class="btn btn-primary" href="afft_sujet" >>Consulter la liste SUJET</a>');
		htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
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
		stasujet = vstasujet
	WHERE 
		numsujet = vnumsujet;
	COMMIT;
END;
/



--3.2.2 Page de validation d'�dition du statut de sujet
-------Appel � la requ�te pa_edit_sujet_stasujet
CREATE OR REPLACE
PROCEDURE ui_execedit_sujet_stasujet
	(
		vnumsujet in number,
		vstasujet in number
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
	htp.title('Edition table SUJET');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 
	
		pa_edit_sujet_stasujet(vnumsujet,vstasujet);
		htp.hr;
		htp.header(2, 'Edition effectu�e dans la table SUJET');
		htp.print('<a class="btn btn-primary" href="afft_sujet" >>Consulter la liste SUJET</a>');
		htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
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
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/



--3.2.3 Formulaire d'�dition du statut du sujet
------- Validation redirige vers ui_execedit_sujet_stasujet
CREATE OR REPLACE PROCEDURE ui_frmadd_sujet_stasujet
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
	htp.title('Edition sujet');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');

	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 	

		htp.header(1, 'Edition sujet');
		htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_sujet_stasujet', 'POST');
		htp.print('<table class="table">');
		htp.tableRowOpen;
		htp.tableData('Numéro du sujet');
		htp.tableData(htf.formText('vnumsujet', 5));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Statut du sujet');
		htp.tableData(htf.formText('vstasujet', 1));
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


--4 Suppression

--4.1.2 Page de validation de suppression
-------Appel � la requ�te pa_del_sujet
CREATE OR REPLACE
PROCEDURE ui_execdel_sujet
	(
		vnumsujet in number
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
	htp.title('Suppression table SUJET');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	
	header(user_id, user_name, user_type, user_right);

	if (user_id >= 0)
	then 	
	
		pa_del_sujet(vnumsujet);
		htp.hr;
		htp.header(2, 'Suppression �l�ment dans la table SUJET');
		htp.print('<a class="btn btn-primary" href="afft_sujet" >Consulter la liste SUJET</a>');
		htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
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
	DELETE FROM MESSAGE WHERE NUMSUJET = numsujet;
	DELETE FROM 
		SUJET
	WHERE 
		numsujet = vnumsujet;
	COMMIT;
END;
/
