function objectsWithId = classifyObject(objects)
    idNumber = 1;
    objects{1}.id = idNumber; 
    
    for i = 1:length(objects)-1
        if (objects{i}.numScan +1) == objects{i+1}.numScan 
            objects{i}.id = idNumber;
            objects{i+1}.id = idNumber;
        else
            idNumber = idNumber+1;  
            objects{i+1}.id = idNumber; 
            
        end
    end
objectsWithId = objects; 
end