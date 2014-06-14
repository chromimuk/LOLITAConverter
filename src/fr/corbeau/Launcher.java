package fr.corbeau;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * @author Benjamin
 *
 */
public class Launcher {


	/**
	 * Main method of the program
	 * @param args
	 */
	public static void main(String[] args) {

		String HTMLFile = "src/hello.html";
		String procedureName = "index";
		convertHTML(HTMLFile, procedureName);

		
		String SQLFile = "src/course.sql";
		String tableName = "posseder";
		convertSQL(SQLFile, tableName);
		
	}


	
	/**
	 * Method to convert a HTML file to a PL/SQL Web Toolkit code
	 * 
	 * @param HTMLFile	the HTML file
	 * @param procedureName	the desired name for the procedure
	 */
	public static void convertHTML(String HTMLFile, String procedureName) {
		List<String> HTMLCode = getCode(HTMLFile);
		List<String> PLCode = HTMLConverter.convertHTMLToPL(HTMLCode);
		String PLSQLCode = HTMLConverter.addHeadings(procedureName, PLCode);
		
		// System.out.println(PLSQLCode);
	}
	
	
	/**
	 * Method to convert a SQL file to a PL/SQL Web Toolkit code
	 * 
	 * @param SQLFile	the SQL file
	 * @param tableName	the name of the table
	 */
	public static void convertSQL(String SQLFile, String tableName) {
		
		List<String> SQLCode = getCode(SQLFile);
		Map<String, Map> proceduresSQL = SQLConverter.convertSQLToPL(SQLCode, tableName);

		Map<String, String> show = (Map<String, String>) proceduresSQL.get("show");
		Map<String, String> insert = (Map<String, String>) proceduresSQL.get("insert");
		Map<String, String> update = (Map<String, String>) proceduresSQL.get("update");
		Map<String, String> delete = (Map<String, String>) proceduresSQL.get("delete");
		
		String code = "-- PROCEDURES CONCERNANT LA TABLE " + tableName.toUpperCase();
		
		
		
		code += "\n\n--1 Affichage des données";
		for (Entry<String, String> entry : show.entrySet()) {
			
			if (entry.getKey().equals("afft_"+tableName)) {
				code += "\n\n--1.1 Affichage de toutes les données de la table";
			}
			else {
				code += "\n\n--1.X ...";
			}
			
			code += "\n";
			code += entry.getValue();
			code += "\n";
		}

		
		code += "\n\n--2 Insertion";
		for (Entry<String, String> entry : insert.entrySet()) {
			
			if (entry.getKey().equals("pa_add_"+tableName)) {
				code += "\n\n--2.1.1 Requête SQL";
			}
			else if (entry.getKey().equals("ui_execadd_"+tableName)) {
				code += "\n\n--2.1.2 Page de validation d'insertion, avec gestion des erreurs";
				code += "\n-------Appel à la requête pa_add_"+tableName;
			}
			else if (entry.getKey().equals("ui_frmadd_"+tableName)) {
				code += "\n\n--2.1.3 Formulaire d'insertion";
				code += "\n------- Validation redirige vers ui_execadd_"+tableName;
			}
			else {
				code += "\n\n--2.X.X ...";
			}
			
			code += "\n";
			code += entry.getValue();
			code += "\n";
		}
		
		
		
		code += "\n\n--3 Edition";
		for (Entry<String, String> entry : update.entrySet()) {
			
			if (entry.getKey().equals("pa_edit_"+tableName)) {
				code += "\n\n--3.1.1 Requête SQL";
			}
			else if (entry.getKey().equals("ui_execedit_"+tableName)) {
				code += "\n\n--3.1.2 Page de validation d'édition";
				code += "\n-------Appel à la requête pa_edit_"+tableName;
			}
			else if (entry.getKey().equals("ui_frmedit_"+tableName)) {
				code += "\n\n--3.1.3 Formulaire d'édition";
				code += "\n------- Validation redirige vers ui_execedit_"+tableName;
			}
			else {
				code += "\n\n--3.X.X ...";
			}
			
			code += "\n";
			code += entry.getValue();
			code += "\n";
		}
		
		
		code += "\n\n--4 Suppression";
		for (Entry<String, String> entry : delete.entrySet()) {
			
			if (entry.getKey().equals("pa_del_"+tableName)) {
				code += "\n\n--4.1.1 Requête SQL";
			}
			else if (entry.getKey().equals("ui_execdel_"+tableName)) {
				code += "\n\n--4.1.2 Page de validation de suppression";
				code += "\n-------Appel à la requête pa_del_"+tableName;
			}
			else {
				code += "\n\n--4.X.X ...";
			}
			
			code += "\n";
			code += entry.getValue();
			code += "\n";
		}
		
		
		System.out.println(code);
		
	}
	
	
	/**
	 * Get the code, line by line, from a file
	 * TODO: fix deprecation
	 * 
	 * @param filePath	the file
	 * @return			the code
	 */
	@SuppressWarnings({ "deprecation" })
	public static List<String> getCode(String filePath) {

		File file = new File(filePath);
		List<String> code = new ArrayList<String>();

		FileInputStream fis = null;
		BufferedInputStream bis = null;
		DataInputStream dis = null;

		try {
			fis = new FileInputStream(file);
			bis = new BufferedInputStream(fis);
			dis = new DataInputStream(bis);

			while (dis.available() != 0) {
				code.add(dis.readLine().trim());
			}

			fis.close();
			bis.close();
			dis.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}


		return code;
	}




}
