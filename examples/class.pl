#!/usr/bin/perl

use strict;
use warnings;

use threads;
use threads::shared;

package My::Class; {
    use threads::shared qw(share is_shared);
    use Scalar::Util qw(reftype blessed);

    # Constructor
    sub new
    {
        my $class = shift;
        share(my %self);

        # Add arguments to object hash
        while (my $tag = shift) {
            if (!@_) {
                require Carp;
                Carp::croak("Missing value for '$tag'");
            }
            $self{$tag} = _make_shared(shift);
        }

        return (bless(\%self, $class));
    }

    # Adds fields to a shared object
    sub set
    {
        my ($self, $tag, $value) = @_;
        lock($self);
        $self->{$tag} = _make_shared($value);
    }

    # Make a thread-shared version of a complex data structure or object
    sub _make_shared
    {
        my $in = shift;

        # If already thread-shared, then just return the input
        return ($in) if (is_shared($in));

        # Make copies of array, hash and scalar refs
        my $out;
        if (my $ref_type = reftype($in)) {
            # Copy an array ref
            if ($ref_type eq 'ARRAY') {
                # Make empty shared array ref
                $out = &share([]);
                # Recursively copy and add contents
                foreach my $val (@$in) {
                    push(@$out, _make_shared($val));
                }
            }

            # Copy a hash ref
            elsif ($ref_type eq 'HASH') {
                # Make empty shared hash ref
                $out = &share({});
                # Recursively copy and add contents
                foreach my $key (keys(%{$in})) {
                    $out->{$key} = _make_shared($in->{$key});
                }
            }

            # Copy a scalar ref
            elsif ($ref_type eq 'SCALAR') {
                $out = \do{ my $scalar = $$in; };
                share($out);
            }
        }

        # If copy created above ...
        if ($out) {
            # Clone READONLY flag
            if (Internals::SvREADONLY($in)) {
                Internals::SvREADONLY($out, 1);
            }
            # Make blessed copy, if applicable
            if (my $class = blessed($in)) {
                bless($out, $class);
            }
            # Return copy
            return ($out);
        }

        # Just return anything else
        # NOTE: This will generate an error if we're thread-sharing,
        #       and $in is not an ordinary scalar.
        return ($in);
    }
}


package main;

MAIN:
{
    # Create an object containing some complex elements
    my $obj = My::Class->new('bar' => { 'ima' => 'hash' },
                       'baz' => [ qw(shared array) ]);

    # Create a thread
    threads->create(sub {
        # The thread shares the object
        print("Object has a $obj->{'bar'}->{'ima'}\n");

        # Add some more data to the object
        push(@{$obj->{'baz'}}, qw(with five elements));

        # Add a complex field to the object
        $obj->set('funk' => { 'yet' => [ qw(another hash) ] });

    })->join();

    # Show that the object picked up the data set by the thread
    print('Object has a ', join(' ', @{$obj->{'baz'}}), "\n");
    print('Object has yet ', join(' ', @{$obj->{'funk'}->{'yet'}}), "\n");
}

exit(0);

__END__

=head1 NAME

class.pl - Example 'threadsafe' class code

=head1 DESCRIPTION

This example class illustrates how to create hash-based objects that can be
shared between threads using L<threads::shared>.  In addition, it shows how to
permit the objects' fields to contain arbitrarily complex data structures.

=over

=item my $obj = My::Class->new('key' => $value, ...)

The class contructor takes parameters in the form of C<key=E<gt>value> pairs,
and adds them as fields to the newly created shared object.  The I<values> may
be any complex data structures, and are themselves made I<shared>.

=item $obj->set('key' => $value)

This method adds/sets a field for a shared object, making the value for the
field I<shared> if necessary.

=back

=head1 SEE ALSO

L<threads>, L<threads::shared>

=head1 AUTHOR

Jerry D. Hedden, S<E<lt>jdhedden AT cpan DOT orgE<gt>>

=head1 COPYRIGHT AND LICENSE

Copyright 2006 - 2007 Jerry D. Hedden. All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
