class AlterWarehousesAddTriggers < ActiveRecord::Migration[5.2]
  def change

    reversible do |dir|
      dir.up do
        # Create trigger to prevent UPDATE of the alias field
        execute <<-SQL
          CREATE TRIGGER before_warehouses_update BEFORE UPDATE
          ON warehouses
          FOR EACH ROW BEGIN
            SELECT count(1)
              INTO @q
              FROM items
            WHERE item_id LIKE(concat(OLD.alias, '%'));
    
            IF (OLD.alias != NEW.alias) AND (OLD.alias IS NOT NULL OR OLD.alias <> '') THEN
              IF @q > 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'MySql: the warehouse.alias cannot be UPDATED';
              END IF;
            END IF;
          END;
        SQL

        # Create trigger to prevent DELETE the warehouse if exists an item_id with its alias
        execute <<-SQL
          CREATE TRIGGER before_warehouses_delete BEFORE DELETE
          ON warehouses
          FOR EACH ROW BEGIN
            SELECT count(1)
              INTO @q
              FROM items
            WHERE item_id LIKE(concat(OLD.alias, '%'));
            
            IF @q > 0 THEN
              SET @err = concat('MySql: the warehouse cannot be DELETED because exists a item_id with the alias ', OLD.alias);
              SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @err;
            END IF;
          END;
        SQL
      end
      # Drop Trigger
      dir.down do
        execute <<-SQL
          DROP TRIGGER before_warehouses_update;
        SQL
        execute <<-SQL
          DROP TRIGGER before_warehouses_delete;
        SQL
      end
    end
  end
end
