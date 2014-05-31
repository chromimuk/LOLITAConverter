package fr.corbeau;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


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
		String procedureName = "hello";
		// convertHTML(HTMLFile, procedureName);

		
		String SQLFile = "src/course.sql";
		String tableName = "course";
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
		
		System.out.println(PLSQLCode);
	}
	
	
	/**
	 * Method to convert a SQL file to a PL/SQL Web Toolkit code
	 * 
	 * @param SQLFile	the SQL file
	 * @param tableName	the name of the table
	 */
	public static void convertSQL(String SQLFile, String tableName) {
		List<String> SQLCode = getCode(SQLFile);
		Map<String, String> proceduresSQL = SQLConverter.convertSQLToPL(SQLCode, tableName);
		
		
		System.out.println(proceduresSQL.get("ui_execadd"));
		System.out.println();
		System.out.println(proceduresSQL.get("ui_frmadd"));
		System.out.println();
		System.out.println(proceduresSQL.get("pa_add"));
		
	}
	
	
	/**
	 * Get the code, line by line, from a file
	 * TODO: fix deprecation
	 * 
	 * @param filePath	the file
	 * @return			the code
	 */
	@SuppressWarnings({ "deprecation", "resource" })
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
