	<cfparam name="form.isbn" default="0321292693">

	<form action="" method="post">
		<label for="isbn">Enter ISBN:</label>
		<input type="text" name="isbn" size="10">
		<input type="submit" value="Check ISBN">	
	</form>

	<cfinvoke component="isbndb" method="getISBNDetails" returnvariable="details">
		<cfinvokeargument name="isbn" value="#form.isbn#">
	</cfinvoke>


<cfdump var="#details#">