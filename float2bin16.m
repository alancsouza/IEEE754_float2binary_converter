% Floating point to IEEE 754 binary converter
% Adpted from https://www.mathworks.com/matlabcentral/answers/323606-i-am-writing-a-script-to-convert-decimal-to-floating-point-binary-ieee754-however-my-answer-return

% 'bit_precision' can be values of 16, 32 and 64, representing IEEE 754
% standard for half, single and double precision, defining the bias and the size of
% significand (mantissa) and exponent

function binary = float2bin16(x, bit_precision)
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
    
    % Treating constant values
    if x == 0
        binary = zeros(1, bit_precision);
        binary = num2str(binary); % converting output to strign
        binary = binary(~isspace(binary)); % removing spaces
        return
    elseif (strcmp(x, 'NaN'))
        binary = ones(1, bit_precision);
        binary = num2str(binary); % converting output to strign
        binary = binary(~isspace(binary)); % removing spaces
        return
    elseif (strcmp(x, 'Inf'))
        sign = 0;
        exponent = ones(1, exponent_size);
        significand = zeros(1, significand_size);
        binary = [sign exponent significand];
        binary = num2str(binary); % converting output to strign
        binary = binary(~isspace(binary)); % removing spaces
        return
    end
    
    % defining the sign bit:
    sign = 0;
    if x < 0
        sign = 1;
        x = x*(-1);
    end
    
    [x_base2, dec_exponent] = convert_base2(x);
    exponent =  compute_exponent(dec_exponent, exponent_size, bias);
    significand = compute_significand(x_base2, significand_size);
    
    binary = [sign exponent significand];
    binary = num2str(binary); % converting output to strign
    binary = binary(~isspace(binary)); % removing spaces
    
end

function [x_base2, dec_exponent] = convert_base2(x)
    dec_exponent = 0;
    x_base2 = x;

    if abs(x) < 1 
        while abs(x_base2) < 1
            dec_exponent = dec_exponent - 1;
            x_base2 = x/(2.^dec_exponent);
        end
    else
        while abs(x_base2) >= 2
            dec_exponent = dec_exponent + 1;
            x_base2 = x/(2.^dec_exponent);
        end
    end
end

function exponent = compute_exponent(dec_exponent, exponent_size, bias)
    dec_exponent = dec_exponent + bias;
    exponent = zeros(1, exponent_size); 

    for i = exponent_size:-1:1
        exponent(i) = rem(dec_exponent,2);
        dec_exponent= fix(dec_exponent/2);
    end
end


function significand = compute_significand(x_base2, significand_size)
    fraction = x_base2 - 1;
    significand = zeros(1, significand_size);
    
    for i = 1:significand_size
        fraction = fraction*2;
        significand(i) = fix(fraction); 
        fraction = fraction - significand(i);
    end
end

