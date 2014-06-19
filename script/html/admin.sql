CREATE OR REPLACE
PROCEDURE admin
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	user_id number(5);
	user_name varchar2(80);
	user_type varchar2(2);
	user_right varchar2(4);
	vnumsociete number(3);
	user_rights array_t;
	user_right_soc number(1);
	user_right_mem number(1);
BEGIN
	get_info_user(user_id, user_name, user_type);
     	get_info_user_right(user_right);
     	get_info_user_rights(user_rights); 
     	
	user_right_mem := 0;
	user_right_soc := 0;
	     
	FOR i IN user_rights.FIRST .. user_rights.LAST
	LOOP
		-- édition membre
		if(user_rights(i) = 'D05')
		then
			user_right_mem := 1;
		-- édition société
		elsif(user_rights(i) = 'D06')
		then
			user_right_soc := 1;
		end if;
	END LOOP;
  
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('LOLITA');
			htp.print('<link href="https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css" rel="stylesheet">');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');
			header(user_id, user_name, user_type, user_right);
			if(user_id >= 0)
			then
				htp.header(1,'Administration LOLITA');
				htp.br;
				htp.header(2, 'Membre');
				htp.print('<a class="btn btn-primary" href="afft_membre" >Consulter la liste des membres</a>');
				
				if(user_right_mem = 1)
				then
					htp.print('<a class="btn btn-primary" href="ui_frmadd_membre" >Inscrire un membre</a>');
					htp.hr;
				end if;
				
				htp.header(2, 'Droits et statuts');
				htp.print('<a class="btn btn-primary" href="afft_membre_from_stamembre?vstamembre=S05" >Validation inscription membre</a>');
				htp.print('<a class="btn btn-primary" href="ui_frmadd_attribuer" >Attribuer un droit � un membre</a>');
				htp.print('<a class="btn btn-primary" href="ui_frmadd_autoriser" >Ajouter un droit sur un domaine</a>');
				htp.hr;
				
				if(user_right_mem = 1)
				then
					htp.header(2, 'Société');
					Select NUMSOCIETE Into vnumsociete From MEMBRE Where NUMMEMBRE = user_id;
					htp.print('<a class="btn btn-primary" href="ui_frmedit_societe?vnumsociete=' || vnumsociete || '" >Modifier de sa soci�t�</a>');
					htp.hr;
				end if;				
				
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
