package AI::Categorizer::FeatureVector;

sub new {
  my ($package, %args) = @_;
  $args{features} ||= {};
  return bless {features => $args{features}}, $package;
}

sub set {
  my $self = shift;
  $self->{features} = (ref $_[0] ? $_[0] : {@_});
}

sub as_hash {
  my $self = shift;
  return $self->{features};
}

sub length {
  my $self = shift;
  return scalar keys %{$self->{features}};
}

sub clone {
  my $self = shift;
  return ref($self)->new( features => { %{$self->{features}} } );
}

sub intersection {
  my ($self, $other) = shift;
  my $common;
  $other = $other->as_hash if UNIVERSAL::isa($other, __PACKAGE__);

  if (UNIVERSAL::isa($other, 'ARRAY')) {
    $common = {map {exists $self->{features}{$_} ? ($_ => $self->{features}{$_}) : ()} @$other};
  } elsif (UNIVERSAL::isa($other, 'HASH')) {
    $common = {map {exists $self->{features}{$_} ? ($_ => $self->{features}{$_}) : ()} keys %$other};
  }
  return ref($self)->new( features => $common );
}

sub add {
  my ($self, $other) = @_;

  $other = $other->as_has;
  while (my ($k,$v) = each %$other) {
    $self->{features}{$k} += $v;
  }
}

1;