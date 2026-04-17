import { Component, OnInit } from '@angular/core';
import { AlbumService } from 'src/app/service/album.service';
import { Player } from './../../model/player';

@Component({
  selector: 'app-players',
  templateUrl: './players.component.html',
  styleUrls: ['./players.component.css']
})
export class PlayersComponent implements OnInit {
  public players: Array<Player> = [];
  msg!: string;

  constructor(public album: AlbumService) {
    album.getPlayers().subscribe(players => {this.players = players;});
  }

  ngOnInit(): void {
  }

  public addPlayer(str: string): void {
    let np: Player = new Player();
    np.id = this.players.length;
    np.name = str;
    this.album.addPlayer(np).subscribe(player => {this.players.push(player);});
  }

}
