#import "session.mligo" "Session"

type action = Session.action

type createsession_param = {
    total_rounds : nat;
    players : address set;
}

type stopsession_param = {
    sessionId : nat;
}

type play_param = {
    sessionId : nat;
    roundId : nat;
    action : bytes
}

type reveal_param = {
    sessionId : nat;
    roundId : nat;
    player_key : bytes;
    player_secret : nat
}

type t = CreateSession of createsession_param | Play of play_param | RevealPlay of reveal_param | StopSession of stopsession_param
