package VotoLegal::Controller::API::Candidate::Register;
use Moose;
use namespace::autoclean;

BEGIN { extends 'CatalystX::Eta::Controller::REST' }

use DDP;

=head1 NAME

VotoLegal::Controller::API::Candidate::Register - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub register : Chained('/api/candidate/root') : PathPart('register') : ActionClass('REST') { }

sub register_POST {
    my ($self, $c) = @_;

    my $user_rs      = $c->model('DB::User');
    my $candidate_rs = $c->model('DB::Candidate');

    $user_rs->execute($c, for => 'create', with => $c->req->params);
    $candidate_rs->execute($c, for => 'create', with => $c->req->params);

    my $user ;
    my $candidate;
    eval {
        $c->model('DB')->schema->txn_do(sub {
            $user = $user_rs->create({
                username => $c->req->params->{username},
                password => $c->req->params->{password},
                email    => $c->req->params->{email},
            });

            $user->add_to_roles({ id => 2 });

            $candidate = $user->create_related('candidates', {
                name         => $c->req->params->{name},
                popular_name => $c->req->params->{popular_name},
                party_id     => $c->req->params->{party_id},
                cpf          => $c->req->params->{cpf},
                ficha_limpa  => $c->req->params->{ficha_limpa},
                reelection   => $c->req->params->{reelection},
                raising_goal => $c->req->params->{raising_goal},
                active       => 0,
            });
        });
    };

    if ($@) {
        $c->log->error($@);
        die \['register', "can't create user"];
    }

    $self->status_ok($c, entity => {
        user_id      => $user->id,
        candidate_id => $candidate->id,
    });
}


=encoding utf8

=head1 AUTHOR

Junior Moraes,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
