function [ searchflag, timestart, corrdata ] = LTECorrFun( rxdata, corrlen, rsdata )

pssdata1 = ifft( rsdata, 2048 );
pssdata = pssdata1( 1, 1:2048 );
c=sum(abs(pssdata))
corr = zeros( 1, corrlen );
for data_num = 1:corrlen-1024
    for n = 1:length( pssdata )
        corr( data_num ) = corr( data_num ) + rxdata( data_num + n - 1 )*conj(pssdata( n ));
    end 
end 
corrdata = abs( corr );

timestart = find( max( corrdata ) == corrdata );
if max( corrdata ) > 2 * ( sum( corrdata ) - max( corrdata ) ) / ( corrlen - 1 )
    searchflag = 1;
else 
    searchflag = 0;
end 

end 
% Decoded using De-pcode utility v1.2 from file /tmp/tmpmD_rv0.p.
% Please follow local copyright laws when handling this file.

