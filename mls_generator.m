% -------------------------------------------------------------------------
% mls_generator.m
% -------------------------------------------------------------------------
% Generates a maximum length sequence.
% -------------------------------------------------------------------------
% Usage: [mls_output]=mls_generator(n,random_flag);
% -------------------------------------------------------------------------
% Inputs:
% -------------------------------------------------------------------------
%            n - order of the sequence.  An n-th order sequence is 2^n-1
%                samples long.  If the order of the desired sequence is
%                larger than 15, then the output will be saved into
%                multiple files instead of to the workspace.
%  random_flag - set to 1 if a random shifted version is desired, otherwise
%                leave blank or set to 0 to use ones.
% -------------------------------------------------------------------------
% Outputs:
% -------------------------------------------------------------------------
%   mls_output - output sequence.  If the the order is larger than 15, then
%                the mls_output will be set to a string 'saved as files'.
% -------------------------------------------------------------------------
% Notes:
% - Since this code makes use of the GFPRIMDF function, any prime
% polynomial with and order larger than 26 will require use of the GFPRIMFD
% function.  Processing time can get large when using GFPRIMFD.
% -------------------------------------------------------------------------
% T. Streeter, 13 DEC 2006
% -------------------------------------------------------------------------
function mls_output=mls_generator(n,random_flag)

n_big=32; %any MLS larger than this value will be split into seperate files

if n<2
    error('The input order must be 2 or greater')
end

if nargin==1
    random_flag=0;
end

%generate register sequence
%--------------------------
if random_flag==0  %all ones
    register_list=ones(1,n);
elseif random_flag==1 %random
    register_list=round(rand(1,n));
    while sum(register_list)==0 %make sure at least one element is non-zero
        register_list=round(rand(1,n));
    end
else %illegal input for random_flag
    error('random_flag must be either set to zero or one')
end

prim_poly=gfprimdf(n); %obtain the primative polynomial
sum_list=find(prim_poly(1:n)==1); %determine elements from register sequence to be summed

if n<=n_big
    mls_output=zeros(1,2^n-1); %generate empty sequence
    for m=1:2^n-1 %fill the sequence
        %the first element of the register sequence is stored
        mls_output(m)=register_list(1);

        %shift the register sequest and determine the new element from the
        %primitate polynomial:
        register_list=[register_list(2:n) mod(sum(register_list(sum_list)),2)];
    end
else
    disp('The specified order is large.  Output will be saved into seperate files and run time will be long.')

    split_number=(n+1)-n_big;

    for p=1:split_number;
        if p==split_number
            mls_output=zeros(1,2^n_big-1); %generate empty sequence
            for m=1:2^n_big-1
                %the first element of the register sequence is stored
                mls_output(m)=register_list(1);

                %shift the register sequest and determine the new element from the
                %primitate polynomial:
                register_list=[register_list(2:n) mod(sum(register_list(sum_list)),2)];
            end

        else
            mls_output=zeros(1,2^n_big); %generate empty sequence
            for m=1:2^n_big
                %the first element of the register sequence is stored
                mls_output(m)=register_list(1);

                %shift the register sequest and determine the new element from the
                %primitate polynomial:
                register_list=[register_list(2:n) mod(sum(register_list(sum_list)),2)];
            end
        end
        eval(['mls_output_',num2str(p),'of',num2str(split_number),'_order',num2str(n),'=mls_output;']);
        disp(['Saving file ',num2str(p),' out of ',num2str(split_number),'.'])

        save(['mls_output_',num2str(p),'of',num2str(split_number),'_order',num2str(n)],...
            ['mls_output_',num2str(p),'of',num2str(split_number),'_order',num2str(n)]);

    end
    mls_output='saved as files';
end