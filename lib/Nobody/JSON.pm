package Nobody::JSON;
use base 'Exporter';
our(@EXPORT)=qw( encode_json decode_json  );
use JSON::MaybeXS();
sub encode_json {
  JSON::MaybeXS->new({pretty=>1, utf8=>1})->encode(@_);;
};
sub decode_json {
  JSON::MaybeXS->new({pretty=>1, utf8=>1})->decode(@_);;
};
