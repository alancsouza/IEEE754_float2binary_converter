% Convert IEEE 754 floating point binary digits to decimal values
% x is an array of binary digits in the IEEE 754 standard format
% x can also accept a 'char' type

function float = bin2float16(x)
    
    if isa(x, 'char') % converting string to number
       x = x-'0'; 
    end

    bit_precision = length(x);
    
    if bit_precision == 16
        bias = 15;
        significand_size = 10;
        exponent_size = 5;
    elseif bit_precision == 32
        bias = 127;
        significand_size = 23;
        exponent_size = 8;
    elseif bit_precision == 64
        bias = 1023 ;
        significand_size = 52;
        exponent_size = 11;
    else
        error('Precision not supported');        
    end
    
    sign = x(1);
    exponent = x(2:(exponent_size+1));
    significand = x((exponent_size+2):end);
    
    fraction = compute_fraction(significand, significand_size);
    exp = compute_exponent(exponent, exponent_size, bias);
    
    float = (-1)^sign * fraction * 2^(exp);
end

function fraction = compute_fraction(significand, significand_size)
    fraction = 1;
    for i = 1:significand_size
        aux = significand(i) * 2^(-i);
        fraction = fraction + aux;
    end
end

function exp = compute_exponent(exponent, exponent_size, bias)
    exp = 0;
    for i = 1:exponent_size
        aux = exponent(i) * 2^(exponent_size - i);
        exp = exp + aux;
    end
    exp = exp - bias;
end