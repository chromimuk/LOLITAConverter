CREATE OR REPLACE
PROCEDURE admin_expert
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	user_id number(5);
	user_name varchar2(80);
	user_type varchar2(2);
	user_right varchar2(4);
	user_rights array_t;
	user_right_soc number(1);
	user_right_dom number(1);
BEGIN
	get_info_user(user_id, user_name, user_type);
     	get_info_user_right(user_right);
     	get_info_user_rights(user_rights);    
     	
     	user_right_dom := 0;
     	user_right_soc := 0;
     	
     	FOR i IN user_rights.FIRST .. user_rights.LAST
	LOOP
		-- édition domaine
		if(user_rights(i) = 'D04')
		then
			user_right_dom := 1;
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
				htp.header(1,'Administration expert LOLITA');
				htp.br;
				htp.header(2, 'Sujet');
				htp.print('<a class="btn btn-primary" href="afft_sujet" >Edition sujet</a>');
				htp.hr;
				
				-- société
				if(user_right_soc = 1)
				then
					htp.header(2, 'Société');
					htp.print('<a class="btn btn-primary" href="ui_frmadd_societe" >Inscription société</a>');
					htp.hr;
				end if;
				
				-- domaine
				if(user_right_dom = 1)
				then				
					htp.header(2, 'Domaine');
					htp.print('<a class="btn btn-primary" href="ui_frmadd_domaine" >Création domaine</a>');
					htp.print('<a class="btn btn-primary" href="afft_domaine" >Edition domaine</a>');
					htp.print('<a class="btn btn-primary" href="afft_se_specialiser" >Voir les spécialisations</a>');
					htp.print('<a class="btn btn-primary" href="ui_frmadd_se_specialiser" >Ajouter specialisation entre un membre et un domaine</a>');
					htp.hr;
				end if;
				
				htp.header(2, 'Catégorie');
				htp.print('<a class="btn btn-primary" href="afft_categorie" >Afficher catégorie</a>');
				htp.print('<a class="btn btn-primary" href="ui_frmadd_categorie" >Création catégorie</a>');
				htp.print('<a class="btn btn-primary" href="ui_frmadd_posseder" >Attribution catégorie à un domaine</a>');
				htp.hr;
				htp.header(2, 'Langue');
				htp.print('<a class="btn btn-primary" href="afft_langue" >Afficher langue</a>');
				htp.print('<a class="btn btn-primary" href="ui_frmadd_langue" >Création langue</a>');
				htp.print('<a class="btn btn-primary" href="ui_frmadd_parler" >Ajouter une langue parlée à un membre</a>');
				htp.hr;
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
