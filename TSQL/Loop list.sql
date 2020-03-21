/*
Loop through a delimited list
source: https://www.sqlbook.com/advanced/using-sql-to-parse-a-comma-delimited-list-example-code/
date: 12/13/2019

*/

DECLARE @List nvarchar(100)
DECLARE @ListItem nvarchar(10)  -- amend this to a length that will cover the length of your list items (for dd/mm/yyyy it is 10)
DECLARE @Pos int

-- assign a list of dates in format dd/mm/yyyy to our comma delimited list variable
SET @List = '10/12/2007,12/01/2007,22/02/2003'

-- Loop while the list string still holds one or more characters
WHILE LEN(@List) > 0
Begin
       -- Get the position of the first comma (returns 0 if no commas left in string)
       SET @Pos = CHARINDEX(',', @List)

       -- Extract the list item string
       IF @Pos = 0
       Begin
               SET @ListItem = @List
       End
       ELSE
       Begin
               SET @ListItem = SUBSTRING(@List, 1, @Pos - 1)
       End

       -- in the real world you would now do something with the list item string, this could be:
       -- * inserting it into a table
       -- * using it as a parameter in a stored procedure call
       -- * parsing it into a numeric / datetime format to use in a calculation
       -- etc....
       PRINT @ListItem

       -- remove the list item (and trailing comma if present) from the list string
       IF @Pos = 0
       Begin
               SET @List = ''
       End
       ELSE
       Begin
               -- start substring at the character after the first comma
                SET @List = SUBSTRING(@List, @Pos + 1, LEN(@List) - @Pos)
       End
End