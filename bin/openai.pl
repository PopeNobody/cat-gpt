#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
eval 'exec perl -x -wS $0 ${1+"$@"}'
  if 0;
$|++;
use lib "lib";
use common::sense;
use autodie;
use Nobody::Util;
use Nobody::PP;
use JSON::MaybeXS();
use OpenAI::API;

our(@VERSION) = qw( 0 1 0 );
sub encode_json {
  JSON::MaybeXS->new({pretty=>1, utf8=>1})->encode(@_);;
};
sub decode_json {
  JSON::MaybeXS->new({pretty=>1, utf8=>1})->decode(@_);;
};
# uses OPENAI_API_{KEY,URL} environment variables
my $openai = OpenAI::API->new();    
my ($file)=path("conv/current.json");
unless($file->exists) {
  my ($dated)=join(".",$file, serdate);
  say $dated;
  system("echo cp conv/parts/system.json $dated ");
  exit(0);
};
our ($messages,@messages) ; 
*messages=$messages=decode_json($file->slurp);
my $res = $openai->chat(
  messages => \@messages,
);
my $message = $res->{choices}[0]{message};
push(@messages,$message);
my ($dated)=path(join(".",$file, serdate));
my $json=encode_json(\@messages);
open(STDOUT,">","$dated");
open(STDOUT,"|jq");
say $json;
close(STDIN);
close(STDOUT);
unlink($file);
symlink($dated->basename, $file);
