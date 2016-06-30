function str = getCompString(comp)
    switch comp
        case '1'
            str = '>=';
        case '2'
            str = '<=';
        case '3'
            str = '==';
        otherwise
            str = 'unknown';
    end
end