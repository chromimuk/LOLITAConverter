package fr.corbeau;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Methods to convert a HTML file to a PL/SQL Web Toolkit code
 * 
 * @author Benjamin
 *
 */
public class HTMLConverter {

	
	/**
	 * From the HTML Code, converts to PL/SQL code
	 * For each HTML, two possibilities:
	 * 	- it has a direct equivalence in PL/SQL (eg 'head' or 'br/')
	 *  - it does not and needs some modification  
	 * 
	 * @param HTMLCode		the HTML code, in an ArrayList
	 * @return				the equivalent PL/SQL code, in an ArrayList
	 */
	public static List<String> convertHTMLToPL(List<String> HTMLCode) {
		
		List<String> PLCode = new ArrayList<String>();
		
		for (String line: HTMLCode) {
			
			if (hasDirectEquivalence(line)) {
				PLCode.add(Resource.equivalence.get(line));
			}
			else {
				PLCode.add(manageTagWOEquivalence(line));
			}
		}
		
		return PLCode;
	}
	

	/** 
	 * Add the headings of the procedure (Create or replace ...)
	 *  
	 * @param name		the name of the procedure
	 * @param PLCode	the list of PLCode made for now
	 * @return			the complete PLCode 
	 */
	public static String addHeadings(String name, List<String> PLCode) {

		String code = "CREATE OR REPLACE PROCEDURE " + name + " IS\n";
		code += "BEGIN\n";

		for (String pl : PLCode)
			code += "\t" + pl + "\n";

		code += "END;\n";
		code +=	"/";


		return code;
	}





	/**
	 * Manage a tag with an element in it (eg 'h1') or with attributes (eg 'img') 
	 * If the tag is known:
	 * 	1 - Its attributes are saved in a HashMap
	 * 	2 - The PL/SQL code is formatted to take care of these attributes and to add the elements of the tag
	 * Else, the default command 'htp.print' is used
	 * 
	 * @param line		the HTML line
	 * @return			the equivalent PL/SQL code
	 */
	public static String manageTagWOEquivalence(String line) {

		boolean patternFound = false;
		Matcher matcher = null;
		Map<String, String> attributes = null;

		String PLCode = "";


		// starts by checking all the known patterns in the list of patterns

		for (Pattern pattern : Resource.listPatterns) {

			matcher = pattern.matcher(line);

			if (matcher.matches()) {
				attributes = getAttributesOfTheTag(line);
				PLCode = formatPLCodePattern(pattern, line, attributes);
				patternFound = true;
			}
		}

		// if nothing has been found, using 'htp.print' 

		if (!patternFound) {
			PLCode = "htp.print('" + line + "');";
		}


		return PLCode;
	}

	
	

	/**
	 * Return the attributes in a HashMap 
	 * 
	 * @param line	the line of code
	 * @return		a HashMap with the attributes
	 */
	public static Map<String, String> getAttributesOfTheTag(String line) {
		
		Map<String, String> attributes = new HashMap<String, String>();
		
		String[] att = getAttributes(line);
		int attLength = att.length;
		
		
		if (attLength > 0) {
			
			for (int i = 0; i < attLength-1; i++) {
				String[] a = att[i].split("=");
				attributes.put(a[0], a[1]);
			}
			
		}	
		
		return attributes;
	}

	
	
	
	
	/**
	 * Tags with elements or attributes needs to be formatted to be used in PL/SQL
	 * If there is no attributes, Resource.equivalence (// with element) is normally used
	 * 
	 * @param pattern		the pattern discoverd (eg h1 or img tags)
	 * @param line			the entire line where the tags is discovered
	 * @param attributes	a HashMap of the attributes (empty if no attributes)
	 * @return				the formatted code
	 */
	public static String formatPLCodePattern(Pattern pattern, String line, Map<String, String> attributes) {

		String PLCode = "";

		if (attributes.isEmpty()) {
			String lineWithoutTags = line.replaceAll("\\<.*?\\>", "");
			PLCode = Resource.equivalence.get(pattern.toString())+lineWithoutTags+"');";
		}
		else {

			// TODO: make the difference between properties and attributes (eg src and width)
			String cattributes = "cattributes => '";

			for (Entry<String, String> entry : attributes.entrySet()) {
				cattributes += "" + entry.getKey() + "=" + entry.getValue() + " ";
			}

			cattributes += "'";
			PLCode = Resource.equivalence.get(pattern.toString()) + cattributes+");";
		}

		return PLCode;
	}





	/**
	 * Separate the different attributes from the tag 
	 * 
	 * 
	 * @param line	the entire line fo code
	 * @return		an array with all the attributes of the tag
	 */
	public static String[] getAttributes(String line) {

		String[] attributes = {};

		Pattern pattern = Pattern.compile(".*=.*");
		Matcher matcher = pattern.matcher(line);

		while(matcher.find()) {
			attributes = line.split("\" ");
		}

		// dirty fix to remove the '<tag' 
		if (attributes.length > 0) {

			attributes[0] = attributes[0].substring(attributes[0].indexOf(" ")+1);

			for (int i=0; i<attributes.length; i++) {
				attributes[i] += "\"";
			}
		}

		return attributes;
	}




	/**
	 * Check if the line is only composed of a simple tag and therefore have a direct equivalent command in PL/SQL
	 * 
	 * @param line		the line to check
	 * @return			the equivalent PL/SQL code
	 */
	public static boolean hasDirectEquivalence(String line) {
		return (Resource.equivalence.get(line) != null);
	}


}
