pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer currentPlayer: null
    property MprisPlayer oldPlayer: null
    property var players: []

    function getPlayer() {
        return root.currentPlayer || root.oldPlayer;
    }

    function updatePlayer() {
        var preferred = null;
        var fallback = null;

        for (var i = 0; i < root.players.length; ++i) {
            var player = root.players[i];
            if (!player)
                continue;

            if (!fallback)
                fallback = player;

            if (player.playbackState === MprisPlaybackState.Playing) {
                preferred = player;
                break;
            }
        }

        var next = preferred || fallback || null;

        if (next === root.currentPlayer)
            return;

        root.oldPlayer = root.currentPlayer;
        root.currentPlayer = next;
    }

    function handlePlayerChanged(player: MprisPlayer) {
        if (!player)
            return;

        if (root.players.indexOf(player) === -1)
            root.players = root.players.concat([player]);

        if (player === root.currentPlayer) {
            // Ensure bindings react when the current player updates its metadata state.
            root.currentPlayer = player;
            return;
        }

        if (player.playbackState === MprisPlaybackState.Playing) {
            root.oldPlayer = root.currentPlayer;
            root.currentPlayer = player;
            return;
        }

        if (!root.currentPlayer || root.currentPlayer.playbackState !== Mpris.PlaybackState.Playing)
            root.updatePlayer();
    }

    function playerDestroyed(player: MprisPlayer) {
        var index = root.players.indexOf(player);
        if (index !== -1)
            root.players = root.players.slice(0, index).concat(root.players.slice(index + 1));

        if (player === root.currentPlayer) {
            root.oldPlayer = root.currentPlayer;
            root.currentPlayer = null;
            root.updatePlayer();
            return;
        }

        if (player === root.oldPlayer)
            root.oldPlayer = null;
    }

    Instantiator {
        model: Mpris.players

        Connections {
            required property MprisPlayer modelData
            target: modelData

            Component.onCompleted: root.handlePlayerChanged(modelData)
            Component.onDestruction: root.playerDestroyed(modelData)

            function onPlaybackStateChanged() {
                root.handlePlayerChanged(modelData);
            }

            function onMetadataChanged() {
                root.handlePlayerChanged(modelData);
            }
        }
    } 
}