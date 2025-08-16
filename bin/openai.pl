#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
eval 'exec perl -x -wS $0 ${1+"$@"}'
  if 0;
BEGIN { $DB::single=1; }
$|++;
use lib "lib";
use common::sense;
use autodie;
use Nobody::Util;
use Nobody::PP;
use JSON::MaybeXS();
use OpenAI::API;
BEGIN {
  system("mkdir -p log");
  open(STDERR,"|tee log/openai.".(serdate).".log");
  select(STDERR); $|++;
  select(STDOUT); $|++;
};
our(@VERSION) = qw( 0 1 0 );
sub encode_json {
  JSON::MaybeXS->new({pretty=>1, utf8=>1})->encode(@_);;
};
sub decode_json {
  JSON::MaybeXS->new({pretty=>1, utf8=>1})->decode(@_);;
};
# uses OPENAI_API_{KEY,URL} environment variables
my $openai = OpenAI::API->new();    
ddx( $openai->{config} );
my ($file)=path("conv/current.json");
unless($file->exists) {
  my ($dated)=path(join(".",$file, serdate));
  say $dated;
  system("cp conv/parts/system.json $dated ");
  symlink($dated->basename, $file)
};
our ($messages,@messages) ; 
*messages=$messages=decode_json($file->slurp);
if(defined($ENV{DRY_RUN})){
  say STDERR "DRY_RUN is set";
  push(@messages,{ role=>"nobody", content=>serdate() });
} else {
  my $res = $openai->chat(
    "messages" => \@messages,
    "model" => $ENV{OPENAI_API_MOD},
  );
  my $message = $res->{choices}[0]{message};
  push(@messages,$message);
};
my ($dated)=path(join(".",$file, serdate));
my $json=encode_json(\@messages);
open(STDOUT,"|-","tee", $dated);
open(STDOUT,"|jq");
say $json;
close(STDIN);
close(STDOUT);
unlink($file);
symlink($dated->basename, $file);
