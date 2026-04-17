import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { Player } from '../model/player';

@Injectable({
  providedIn: 'root'
})
export class AlbumService {
  public players: Array<Player>;
  private tracker: BehaviorSubject<Array<Player>>;
  
  constructor(private http: HttpClient) {
    this.players = [{id: 0,name:'Jim Bilba'}, {id: 1,name:'Antoine Rigaudeau'},{id: 2,name:'Raymond Kopa'}];
    this.tracker = new BehaviorSubject<Array<Player>>(this.players);
  }

  public getPlayers(): Observable<Array<Player>> {
    return this.http.get<Array<Player>>("api/player/players");
//    return this.tracker.asObservable();
  }

  public addPlayer(player: Player): Observable<Player> {
    return this.http.post<Player>("api/player/player", {"name": player.name});
  }
}
