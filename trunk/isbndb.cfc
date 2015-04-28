<cfcomponent name="isbndb" displayname="ISBNdb" hint="Provides interface to ISBNdb.com's API">
<!--- 
*******************************************************************************
 Copyright (C) 2007 Scott Pinkston
  
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
  
      http://www.apache.org/licenses/LICENSE-2.0
  
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*******************************************************************************

Component: ISBNdb.cfc
Created By: Scott Pinkston (spinkston@ozarka.edu)
Creation Date: 1/27/2007
Description: Provides an interface with ISBNdb.com's API

 --->
	<!--- Enter your AccessKey from isbndb.com/account.  
	The key listed is limited to 100 daily queries so it *might* work for testing --->
	<cfset variables.accessKey = "PITF4P63">

	<cffunction name="getISBNDetails" output="false" hint="Returns struct with book details for a given ISBN">
		<cfargument name="isbn" type="Numeric" hint="the isbn to search for details about" required="true">
		<cfset var results = "">
		<cfset details = structNew()>
		
		<cfhttp url="http://isbndb.com/api/books.xml?access_key=#variables.accessKey#&index1=isbn&value1=#arguments.isbn#&results=details,prices,texts"></cfhttp>
	
		<cfset results = XMLParse(cfhttp.filecontent)>
	
		<cfif isdefined('results.ISBNdb.Booklist.Bookdata.Title.xmlText')>
			<cfset details.title = results.ISBNdb.Booklist.Bookdata.Title.xmlText>
			<cfset details.isbn = results.ISBNdb.Booklist.Bookdata.XmlAttributes.isbn>
			<cfset details.author = results.ISBNdb.Booklist.Bookdata.AuthorsText.xmlText>
			<cfset details.publisher = results.ISBNdb.Booklist.Bookdata.PublisherText.xmlText>
			
			<!--- additional details - summary text--->
			<cfset details.summary =  results.ISBNdb.Booklist.Bookdata.summary.xmlText>
			<cfset details.prices = structNew()>
			
			<!--- loop through prices and add to details.prices structure ---->
			<cfloop from="1" to="#arrayLen(results.ISBNdb.Booklist.BookData.prices.xmlChildren)#" index="i">
				<cfif results.ISBNdb.Booklist.BookData.prices.price[i].xmlAttributes.is_in_stock eq 1>
					<cfset details.prices[i] = structNew()>
					<cfset details.prices[i].storeid = results.ISBNdb.Booklist.BookData.prices.price[i].xmlAttributes.store_id>
					<cfset details.prices[i].storeurl = results.ISBNdb.Booklist.BookData.prices.price[i].xmlAttributes.store_url>
					<cfset details.prices[i].price = results.ISBNdb.Booklist.BookData.prices.price[i].xmlAttributes.price>
					<cfset details.prices[i].check_time = results.ISBNdb.Booklist.BookData.prices.price[i].xmlAttributes.check_time>
				</cfif>	
			</cfloop> 

		</cfif>	
		
		<cfreturn details>
				
	</cffunction>
	

</cfcomponent>