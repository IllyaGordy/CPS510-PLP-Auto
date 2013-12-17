CPS 510 - Database Systems I



This readme contains brief descriptions with regards to the functionality of all code write for the PLP Autos car dealership project. There are also instructions provided for compiling each solution.



TABLE OF CONTENTS
------------------------------------------------------------------
   (I)		REQUIREMENTS
   (II) 	INSTALLATION
   (III)	INSTRUCTIONS
------------------------------------------------------------------






==================================================================
(I)				REQUIREMENTS
==================================================================

- Solaris Operating system
- Intel’s DB2 database management system

==================================================================
(II)			INSTALLATION
==================================================================

1. Access the Solaris operation system. If using Ryerson local Moons this can be done by typing the “ssh turing.acs.ryerson.ca” command in the terminal

2. Setup DB2 environment by entering “. db2init” command

3. Connect to the initialize database by entering “db2 connect to db2data”

4. You should now have successfully set up the local DB2 environment. Now copy over two files to the Solaris systems, this files are plpAutoDatabase.sh and sqlCommands.txt

5. Type in “sh plpAutoDatabse.sh” to enter the application menu.

==================================================================
(III)			INSTRUCTIONS
==================================================================

- Initially you are greeted with a menu options to Initialize DB2, create tables, drop tables, populate tables, show a table, show min menu, quit. At any point in time you can type the “?” for help, which should bring you back to the original menu. 

- To get started type “init” to initialize the DB2 database environment. Once the command has executed you should see a list of characteristics displays and five SQL commands successfully completed. 

- No you should create the default tables using the “ct” command. If all the tables have been created it should tell you “Initial table structure created!” You now have all the necessary tables with no values stored in them. 

- The additional file(sqlCommands.txt.) contains a list of SQL commands to populate the table with dummy data in order to show the functionality of the database. To populate the tables type in the “pt” command. You should see a long list of SQL commands that hopefully completed successfully.

- To view an individual table you can type the “st” command. It will prompt to type in the name of the table to view. There are 5 tables to view: Dealership, Customer, SalesPerson, Transaction, Inventory. 

- To drop the table structure type in the “dt” command.

- If you are done interacting with the applicant type in the “quit” command to exit. 


------------------------------------------------------------------




