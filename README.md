# Game Database Project

This project loads video game data into a normalized MySQL database.

## Setup Instructions

1. Install MySQL and create a database named `games`
   
2. Run the schema script:
   CLI -> mysql -u root -p < create_tables.sql
   OR
   run script directly within MySQL -> file > open sql script
   
3. Install Python dependencies:
   pip install mysql-connector-python

4. Open `insert-table.py` and update the DB password in `DB_CONFIG`
  
5. Place all 6 CSV files in the same directory
   
6. Run the import:
   python insert-table.py
   
7. Done
