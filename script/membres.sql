CREATE OR REPLACE PROCEDURE pa_add_membre
(
	vnummembre in number,
	vnumsociete in number,
	vnumlangue in number,
	vtypmembre in varchar2,
	vnommembre in varchar2,
	vpremembre in varchar2,
	vmaimembre in varchar2,
	vmdpmembre in varchar2,
	vdtemembre in date,
	vposmembre in varchar2,
	vphomembre in varchar2,
	vdscexpert in clob,
	vtelexpert in varchar2
)
IS
BEGIN
INSERT INTO membre VALUES
(
	vnummembre,
	vnumsociete,
	vnumlangue,
	vtypmembre,
	vnommembre,
	vpremembre,
	vmaimembre,
	vmdpmembre,
	vdtemembre,
	vposmembre,
	vphomembre,
	vdscexpert,
	vtelexpert
);
COMMIT;
END;
/



CREATE OR REPLACE PROCEDURE ui_frmadd_membre
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout dans la table membre');
	htp.br;
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_membre', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('Numero membre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Numero societe');
	htp.tableData(htf.formText('vnumsociete', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Numero langue');
	htp.tableData(htf.formText('vnumlangue', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Type membre');
	htp.tableData(htf.formText('vtypmembre', 1));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Nom membre');
	htp.tableData(htf.formText('vnommembre', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Prenom membre');
	htp.tableData(htf.formText('vpremembre', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Mail membre');
	htp.tableData(htf.formText('vmaimembre', 50));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('MDP');
	htp.tableData(htf.formText('vmdpmembre', 20));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Date inscri');
	htp.tableData(htf.formText('vdtemembre', 10));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Poste');
	htp.tableData(htf.formText('vposmembre', 40));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Photo');
	htp.tableData(htf.formText('vphomembre', 100));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Description');
	htp.tableData(htf.formText('vdscexpert', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Telephone');
	htp.tableData(htf.formText('vtelexpert', 20));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


CREATE OR REPLACE PROCEDURE ui_execadd_membre
(
	vnummembre in number,
	vnumsociete in number,
	vnumlangue in number,
	vtypmembre in varchar2,
	vnommembre in varchar2,
	vpremembre in varchar2,
	vmaimembre in varchar2,
	vmdpmembre in varchar2,
	vdtemembre in date,
	vposmembre in varchar2,
	vphomembre in varchar2,
	vdscexpert in clob,
	vtelexpert in varchar2
)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	pa_add_membre(vnummembre,vnumsociete,vnumlangue,vtypmembre,vnommembre,vpremembre,vmaimembre,vmdpmembre,vdtemembre,vposmembre,vphomembre,vdscexpert,vtelexpert);
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


CREATE OR REPLACE PROCEDURE afft_membre
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst IS
		SELECT 
			M.NUMMEMBRE, S.NOMSOCIETE, L.LIBLANGUE, M.TYPMEMBRE, M.NOMMEMBRE, M.PREMEMBRE, M.MAIMEMBRE, M.DTEMEMBRE, M.POSMEMBRE
		FROM 
			SOCIETE S
			Inner Join MEMBRE M
			On M.NUMSOCIETE = S.NUMSOCIETE
			Inner Join LANGUE L
			On L.NUMLANGUE = M.NUMLANGUE
		ORDER BY
			M.NUMMEMBRE
		;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Table membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste membre');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
		htp.tableheader('N°');
		htp.tableheader('Type');
		htp.tableheader('Membre');
		htp.tableheader('Societe');
		htp.tableheader('Langue maternelle');
		htp.tableheader('Mail');
		htp.tableheader('Inscrit le');
		htp.tableheader('Poste');
	htp.tableRowClose;
	FOR rec IN lst loop
		if rec.typmembre = 'E' then
			htp.tableRowOpen(cattributes => 'class=success');
		elsif rec.typmembre = 'C' then
			htp.tableRowOpen(cattributes => 'class=info');
		else
			htp.tableRowOpen;
		end if;
		htp.tableData(rec.nummembre);
		htp.tableData(rec.typmembre);
		htp.tableData(htf.anchor('afft_membre_from_nummembre?vnummembre=' || rec.nummembre, rec.premembre || ' ' || rec.nommembre));
		htp.tableData(rec.nomsociete);
		htp.tableData(rec.liblangue);
		htp.tableData(rec.maimembre);
		htp.tableData(rec.dtemembre);
		htp.tableData(rec.posmembre);
		htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/






Create or replace procedure afft_membre_from_nummembre
	(vnummembre number default 1) is
		rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
		vnommembre varchar2(30);
		vpremembre varchar2(30);
		vphomembre clob;
		Cursor lst is 
			SELECT 
				M.NUMMEMBRE, S.NOMSOCIETE, L.LIBLANGUE, M.TYPMEMBRE, M.MAIMEMBRE, M.DTEMEMBRE, M.POSMEMBRE, M.PHOMEMBRE, M.DSCEXPERT, M.TELEXPERT
			FROM 
				SOCIETE S
				Inner Join MEMBRE M
				On M.NUMSOCIETE = S.NUMSOCIETE
				Inner Join LANGUE L
				On L.NUMLANGUE = M.NUMLANGUE
			WHERE
				M.NUMMEMBRE = vnummembre;
Begin
	Select NOMMEMBRE, PREMEMBRE, PHOMEMBRE Into vnommembre, vpremembre, vphomembre From MEMBRE Where NUMMEMBRE = vnummembre;
	htp.htmlOpen;
	htp.headopen;
	htp.title('Profil membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headclose;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Profil de ' || vnommembre || ' ' || vpremembre);
	htp.br;
	htp.print('<img src="https://dl.dropboxusercontent.com/u/21548623/' || vphomembre || '" />');
	htp.br;
	htp.br;
	htp.print('<table class="table">');
	htp.tableRowOpen;
		htp.tableheader('N°');
		htp.tableheader('Type');
		htp.tableheader('Societe');
		htp.tableheader('Langue maternelle');
		htp.tableheader('Mail');
		htp.tableheader('Inscrit le');
		htp.tableheader('Poste');
	htp.tableRowClose;
	for rec in lst loop
		htp.tableRowOpen;
		htp.tableData(rec.nummembre);
		htp.tableData(rec.typmembre);
		htp.tableData(rec.nomsociete);
		htp.tableData(rec.liblangue);
		htp.tableData(rec.maimembre);
		htp.tableData(rec.dtemembre);
		htp.tableData(rec.posmembre);
		htp.tableRowClose;
	end loop;
	htp.tableClose;
	htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
End;
/


