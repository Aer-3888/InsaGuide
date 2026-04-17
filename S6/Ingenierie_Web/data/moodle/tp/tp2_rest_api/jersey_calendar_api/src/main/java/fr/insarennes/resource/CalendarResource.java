package fr.insarennes.resource;

import fr.insarennes.model.*;
import io.swagger.annotations.Api;
import java.net.HttpURLConnection;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.inject.Singleton;
import javax.ws.rs.*;
import javax.ws.rs.client.Entity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.apache.log4j.BasicConfigurator;

@Singleton
@Path("calendar")
@Api(value = "calendar")
public class CalendarResource {
	private static final Logger LOGGER = Logger.getAnonymousLogger();

	// Static blocks are used to parametrized static objects of the class.
	static {
		// Define the level of importance the Logger has to consider.
		// The logged messages with an importance lower than the one defined here will be ignored.
		LOGGER.setLevel(Level.ALL);

		BasicConfigurator.configure();
		org.apache.log4j.Logger.getRootLogger().setLevel(org.apache.log4j.Level.WARN);
	}

	private final Agenda agenda;

	public CalendarResource() {
		super();
		agenda = new Agenda();

//	 	You can add here calendar elements to add by default in the database of the application.
//	 	For instance:
//			Enseignant ens = new Enseignant("Blouin");
//			Matiere mat = new Matiere("Web", 3);
//
//			TD td = new TD(mat, LocalDate.of(2015, Month.JANUARY, 2).atTime(8, 0), ens, Duration.ofHours(2));
//			agenda.addCours(td);
//
//			LOGGER.log(Level.INFO, "Added during the creation of the calendar resource:");
//			LOGGER.log(Level.INFO, "a Enseignant: " + ens);
//			LOGGER.log(Level.INFO, "a Matiere: " + mat);
//			LOGGER.log(Level.INFO, "a TD: " + td);
	}


	//curl -X POST "http://localhost:8080/calendar/ens/Foo"
	@POST
	@Path("ens/{name}")
	//@Produces(MediaType.APPLICATION_XML)
	//@Produces(Response.class)
	public Response postEnseignant(@PathParam("name") final String name) {
		final Enseignant ens = new Enseignant(name);
		try {
			agenda.addEnseignant(ens);
		}catch(final IllegalArgumentException ex) {
			throw new WebApplicationException(Response.status(HttpURLConnection.HTTP_BAD_REQUEST, ex.getMessage()).build());
		}
		//return ens;
		return Response.status(Response.Status.OK).entity(ens).build();
	}

	@POST
	@Path("mat/{annee}/{name}")
	//@Produces(MediaType.APPLICATION_XML)
	//@Produces(Response.class)
	public Response postMatiere(@PathParam("annee") final int annee, @PathParam("name") final String name) {
		final Matiere mat = new Matiere(name, annee);
		try {
			agenda.addMatiere(mat);
		} catch(final IllegalArgumentException ex) {
			throw new WebApplicationException(Response.status(HttpURLConnection.HTTP_BAD_REQUEST, ex.getMessage()).build());
		}
		//return ens;
		return Response.status(Response.Status.OK).entity(mat).build();
	}

	@PUT
	@Path("mat/{id}/{newname}")
	//@Produces(MediaType.APPLICATION_XML)
	//@Produces(Response.class)
	public Response patchMatiere(@PathParam("id") final int id, @PathParam("newname") final String newname) {
		final Matiere mat = agenda.getMatiere(id);
		if (mat == null) {
			throw new WebApplicationException(Response.status(HttpURLConnection.HTTP_BAD_REQUEST).build());
		}

		// Modify the subject
		mat.setName(newname);
		//return ens;
		return Response.status(Response.Status.OK).entity(mat).build();
	}

	@GET
	@Path("mat/{id}")
	//@Produces(MediaType.APPLICATION_XML)
	//@Produces(Response.class)
	public Response getMatiere(@PathParam("id") final int id) {
		final Matiere mat = agenda.getMatiere(id);
		if (mat == null) {
			return Response.status(Response.Status.NOT_FOUND).entity(Entity.text("")).build();
		}
		//return ens;
		return Response.status(Response.Status.OK).entity(mat).build();
	}

	@DELETE
	@Path("mat/{id}")
	//@Produces(MediaType.APPLICATION_XML)
	//@Produces(Response.class)
	public Response delMatiere(@PathParam("id") final int id) {
		final boolean action = agenda.delMatiere(id);
		return Response.status(action ? Response.Status.OK : Response.Status.NOT_FOUND).entity(Entity.text("")).build();
	}

	@POST
	@Path("cours/new")
	@Consumes(MediaType.APPLICATION_XML)
	@Produces(MediaType.APPLICATION_XML)
	public Response newCourse(Cours c) {
		// Check presence of everything
		agenda.addCours(c);
		return Response.status(Response.Status.OK).entity(c).build();
	}
}
