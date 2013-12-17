#!/bin/bash

# Main menu
print_menu() {
	echo ""
	echo "=========================================================="
	echo "MAIN MENU -- PLP AUTO DATABASE"
	echo "=========================================================="
	echo "Please select an operation to perform from the menu below:"
	echo "    [init] -- Initialize DB2"
	echo "    [ct]   -- Create tables"
	echo "    [dt]   -- Drop tables"
	echo "    [ar]   -- Add a record"
	echo "    [dr]   -- Delete a record"
	echo "    [ac]   -- Add a column"
	echo "    [dc]   -- Delete a column"
	echo "    [pt]   -- Populate tables"
	echo "    [st]   -- Show a table"
	echo "    [menu] -- Show main menu"
	echo "    [quit] -- Terminate menu script"
	echo "=========================================================="
	echo ""
}

# Initialize DB2 and and database environment
initialize() {
	echo "Initializing database environment..."
	
	. db2init
	sleep 5
	
	echo "Database initialized!"
	echo "Establishing a connection to the database..."
	
	db2 "connect to db2data"
	
	echo "Connection established."
	
	drop_tables
}

# Create tables
create_tables() {
	echo "Creating initial table structures..."
	
	echo ""
	
	# We need to designate tables with primary keys and have foreign keys in others
	# Below, keys are being defined independently
	# Could use table SalesPerson for primary SPID and table Dealership for DID
	# Could create a new table for Customer, database containing all past/current customer details for CID
	# I've restructured the Transactions table slightly, I've pulled all the customer-related information and placed it in a separate table called Customer. Customer's information can be retrieved by using their CID and referencing table Customer.
	
	db2 "CREATE TABLE Dealership(
			DID int NOT NULL, 
			City char(20),
			
			PRIMARY KEY (DID)
			)"
	
	echo ""
	
	db2 "CREATE TABLE Customer(
			CID int NOT NULL, 
			FirstName char(20), 
			LastName char(20), 
			Telephone char(8), 
			City char(20), 
			PostalCode char(8),
			StreetName char(40),
			
			PRIMARY KEY (CID)
			)"
	
	echo ""
	
	db2 "CREATE TABLE SalesPerson(
			SPID int NOT NULL, 
			FirstName char(20), 
			LastName char(20), 
			DID int NOT NULL,
			
			PRIMARY KEY (SPID),
			FOREIGN KEY (DID) REFERENCES Dealership(DID)
			)"
	
	echo ""
	
	db2 "CREATE TABLE Transaction(
			CID int NOT NULL, 
			TID int NOT NULL, 
			Date timestamp, 
			TransactionType char(25),
			VIN char(17) NOT NULL,
			PaymentType char(15),
			Amount integer, 
			SPID int, 
			DID int,
			
			PRIMARY KEY (TID),
			FOREIGN KEY (CID) REFERENCES Customer(CID),
			FOREIGN KEY (DID) REFERENCES Dealership(DID)
			)"
	
	echo ""
	
	db2 "CREATE TABLE Inventory(
			Date timestamp, 
			DateDeliveredDeal timestamp, 
			VIN char(17) NOT NULL,
			Model char(12),
			Make char(8),
			Year integer, 
			MSRP integer, 
			WarrantyType char(18),
			SoldFlag integer, 
			DateDeliveredCust timestamp, 
			DateService timestamp, 
			SPID int NOT NULL, 
			DID int NOT NULL,
			
			PRIMARY KEY (VIN),
			FOREIGN KEY (SPID) REFERENCES SalesPerson(SPID),
			FOREIGN KEY (DID) REFERENCES Dealership(DID)
			)"
	
	echo ""
	
	echo "Intial table structures created!"
}

# Drop tables
drop_tables() {
	echo "Dropping previous initial table structures..."
	
	echo ""
	
	db2 "DROP TABLE Dealership"

	echo ""
	
	db2 "DROP TABLE Customer"
	
	echo ""
	
	db2 "DROP TABLE SalesPerson"
	
	echo ""
	
	db2 "DROP TABLE Transaction"
	
	echo ""
	
	db2 "DROP TABLE Inventory"
	
	echo ""
	
	echo "Intial table structures dropped!"
}

# Populate the tables from a file containing all the SQL commands
# Example:
#
#	db2 "INSERT INTO table_name
#		VALUES (value1,value2,value3,...
#		)";
populate_tables() {
    while read line
    do
        db2 "$line"
    done < sampleData.txt
}

# Print the specified table
show_table() {
	echo -n "Enter the name of a table you would like to view: "
	read tname
	echo "Generating view for table $tname..."
	db2 "SELECT * FROM $tname"
}

# Add a record
add_record() {
	echo -n "Enter the name of a table you would like to add a record to: "
	read tname
	db2 "SELECT * FROM $tname"
	echo -n "Enter the new record values for $tname (separated by commas): "
	read rvalues
	db2 "INSERT INTO $tname VALUES ($rvalues)"
	echo "Record successfully added to $tname!"
}

# Delete a record
delete_record() {
	echo -n "Enter the name of a table you would like to delete a record from: "
	read tname
	db2 "SELECT * FROM $tname"
	echo -n "Enter a unique key identifier for the record you would like to delete (column=value): "
	read condition
	db2 "DELETE FROM $tname WHERE $condition"
	echo "Record successfully deleted from $tname!"
}

# Add a column
add_column() {
	echo -n "Enter the name of a table you would like to add a column to: "
	read tname
	db2 "SELECT * FROM $tname"
	echo -n "Enter a new column name: "
	read cname
	echo -n "Enter the new column type: "
	read ctype
	db2 "ALTER TABLE $tname ADD $cname $ctype"
	echo "Column successfully added to $tname!"
}

# Delete a column
delete_column() {
	echo -n "Enter the name of a table you would like to delete a column from: "
	read tname
	db2 "SELECT * FROM $tname"
	echo -n "Enter the column name: "
	read cname
	db2 "ALTER TABLE $tname DROP $cname"
	echo "Column successfully deleted from $tname!"
}

# Show menu
print_menu

# Main loop
while :
do
	echo -n "Select an option (? for help): "
	read option
	
	if [ "$option" == "init" ]; then
		initialize
	elif [ "$option" == "ct" ]; then
		create_tables
	elif [ "$option" == "dt" ]; then
		drop_tables
	elif [ "$option" == "ar" ]; then
		add_record
	elif [ "$option" == "dr" ]; then
		delete_record
	elif [ "$option" == "ac" ]; then
		add_column
	elif [ "$option" == "dc" ]; then
		delete_column
	elif [ "$option" == "pt" ]; then
		populate_tables
	elif [ "$option" == "st" ]; then
		show_table
	elif [ "$option" == "?" ]; then
		print_menu
	elif [[ "$option" == "clear" || "$option" == "cls" ]]; then
		clear
	elif [ "$option" == "quit" ]; then 
		break
	else
		echo "Invalid menu choice selected."
	fi
done

echo "$0: Terminated!"
echo "Goodbye!"

exit

