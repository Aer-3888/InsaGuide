package fr.insarennes;

import com.github.hanleyt.JerseyExtension;
import fr.insarennes.model.Enseignant;
import fr.insarennes.model.Matiere;
import fr.insarennes.model.CM;
import fr.insarennes.resource.CalendarResource;
import fr.insarennes.utils.MyExceptionMapper;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Application;
import javax.ws.rs.core.Response;
import org.apache.log4j.BasicConfigurator;
import org.glassfish.jersey.server.ResourceConfig;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.RegisterExtension;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class TestCalendarResource {
	@RegisterExtension JerseyExtension jerseyExtension = new JerseyExtension(this::configureJersey);

	Application configureJersey() {
		return new ResourceConfig(CalendarResource.class)
			.register(MyExceptionMapper.class)
			.property("jersey.config.server.tracing.type", "ALL");
	}

	@BeforeAll
	public static void beforeClass() {
		BasicConfigurator.configure();
		org.apache.log4j.Logger.getRootLogger().setLevel(org.apache.log4j.Level.WARN);
	}

	@Test
	void testPostEnseignantOK(final WebTarget target) {
		// Asks the addition of the teacher object to the server.
		// target(...) is provided by the JerseyTest class to ease the writting of the tests
		// the URI "calendar/ens" first identifies the service ("calendar") to which the request will be sent.
		// "ens" permits the identification of the server operation that will process the request.
		// post(...) corresponds to the HTTP verb POST.
		// To POST an object to the server, this object must be serialised into a standard format: XML and JSON
		// Jersey provides operations (Entity.xml(...)) and processes to automatically serialised objects.
		// To do so (for both XML and Json), the object's class must be tagged with the annotation @XmlRootElement (see Enseignant.java)
		// A Response object is returned by the server.
		Response responseAfterPost = target
			.path("calendar/ens/Cellier")
			.request()
			.post(Entity.text(""));
		// This Response object provides a status that can be checked (see the HTTP header status picture in the subject).
		assertEquals(Response.Status.OK.getStatusCode(), responseAfterPost.getStatus());
		// The Response object may also embed an object that can be read (give the expected class as parameter).
		Enseignant ensWithID = responseAfterPost.readEntity(Enseignant.class);
		// The two Enseignant instances must be equals.
		assertEquals("Cellier", ensWithID.getName());
		// But their ID will differ since the instance returned by the server has been serialised in the database and thus
		// received a unique ID (see the JPA practice session).
		assertTrue(ensWithID.getId() > 0);
	}

	@Test
	void testPostMatiereOK(final WebTarget target) {
		// Asks the addition of the teacher object to the server.
		// target(...) is provided by the JerseyTest class to ease the writting of the tests
		// the URI "calendar/ens" first identifies the service ("calendar") to which the request will be sent.
		// "ens" permits the identification of the server operation that will process the request.
		// post(...) corresponds to the HTTP verb POST.
		// To POST an object to the server, this object must be serialised into a standard format: XML and JSON
		// Jersey provides operations (Entity.xml(...)) and processes to automatically serialised objects.
		// To do so (for both XML and Json), the object's class must be tagged with the annotation @XmlRootElement (see Enseignant.java)
		// A Response object is returned by the server.
		Response responseAfterPost = target
				.path("calendar/mat/2021/Web")
				.request()
				.post(Entity.text(""));
		// This Response object provides a status that can be checked (see the HTTP header status picture in the subject).
		assertEquals(Response.Status.OK.getStatusCode(), responseAfterPost.getStatus());
		// The Response object may also embed an object that can be read (give the expected class as parameter).
		Matiere matWithID = responseAfterPost.readEntity(Matiere.class);
		// The two Matiere instances must be equals.
		assertEquals("Web", matWithID.getName());
		assertEquals(2021, matWithID.getAnnee());
		// But their ID will differ since the instance returned by the server has been serialised in the database and thus
		// received a unique ID (see the JPA practice session).
		assertTrue(matWithID.getId() > 0);
	}

	@Test
	void testPatchMatiereOK(final WebTarget target) {
		// Asks the addition of the teacher object to the server.
		// target(...) is provided by the JerseyTest class to ease the writting of the tests
		// the URI "calendar/ens" first identifies the service ("calendar") to which the request will be sent.
		// "ens" permits the identification of the server operation that will process the request.
		// post(...) corresponds to the HTTP verb POST.
		// To POST an object to the server, this object must be serialised into a standard format: XML and JSON
		// Jersey provides operations (Entity.xml(...)) and processes to automatically serialised objects.
		// To do so (for both XML and Json), the object's class must be tagged with the annotation @XmlRootElement (see Enseignant.java)
		// A Response object is returned by the server.
		Response responseAfterPost = target
				.path("calendar/mat/2021/Data")
				.request()
				.post(Entity.text(""));
		Matiere matWithID = responseAfterPost.readEntity(Matiere.class);
		Response responseAfterPatch = target
				.path("calendar/mat/" + matWithID.getId() + "/BDD")
				.request()
				.put(Entity.text(""));
		Matiere finMatWithID = responseAfterPatch.readEntity(Matiere.class);
		// This Response object provides a status that can be checked (see the HTTP header status picture in the subject).
		assertEquals(Response.Status.OK.getStatusCode(), responseAfterPatch.getStatus());
		// The Response object may also embed an object that can be read (give the expected class as parameter).
		// The two Matiere instances must be equals.
		assertEquals("BDD", finMatWithID.getName());
		assertEquals(2021, finMatWithID.getAnnee());
		// But their ID will differ since the instance returned by the server has been serialised in the database and thus
		// received a unique ID (see the JPA practice session).
		assertTrue(finMatWithID.getId() > 0);
	}

	@Test
	void testGetMatiereOK(final WebTarget target) {
		// A Response object is returned by the server.
		Response responseAfterPost = target
				.path("calendar/mat/2021/Graphs")
				.request()
				.post(Entity.text(""));
		Matiere matWithID = responseAfterPost.readEntity(Matiere.class);
		Response responseAfterGet = target
				.path("calendar/mat/" + matWithID.getId())
				.request()
				.get();
		Matiere finMatWithID = responseAfterGet.readEntity(Matiere.class);
		// This Response object provides a status that can be checked (see the HTTP header status picture in the subject).
		assertEquals(Response.Status.OK.getStatusCode(), responseAfterGet.getStatus());
		// The two Matiere instances must be equals.
		assertEquals("Graphs", finMatWithID.getName());
		assertEquals(2021, finMatWithID.getAnnee());
		// But their ID will differ since the instance returned by the server has been serialised in the database and thus
		assertTrue(finMatWithID.getId() > 0);
		assertTrue(matWithID.getId() > 0);
	}

	void testDelMatiereOK(final WebTarget target) {
		// A Response object is returned by the server.
		Response responseAfterPost = target
				.path("calendar/mat/2021/Graphs")
				.request()
				.post(Entity.text(""));
		assertEquals(200, responseAfterPost.getStatus());
		Matiere matWithID = responseAfterPost.readEntity(Matiere.class);
		assertEquals("Graphs", matWithID.getName());
		assertEquals(2021, matWithID.getAnnee());
		// Delete with ID
		Response responseAfterDel = target
				.path("calendar/mat/" + matWithID.getId())
				.request()
				.delete();
		assertEquals(200, responseAfterDel.getStatus());
		String delRet = responseAfterDel.readEntity(String.class);
		assertEquals("", delRet);

		// Get with ID
		Response responseAfterGet = target
				.path("calendar/mat/" + matWithID.getId())
				.request()
				.get();
		assertEquals(204, responseAfterGet.getStatus());
		String delRetTwo = responseAfterGet.readEntity(String.class);
		assertEquals("", delRetTwo);
	}

	@Test
	void testAddCMOK(final WebTarget target) {
		// A Response object is returned by the server.
		Matiere mat = new Matiere("Web", 2021);
		Enseignant bl = new Enseignant("Blouin");
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd-HH:mm");
		LocalDateTime ldt = LocalDateTime.parse("2021-05-18-13:00", dtf);
		Duration dur = Duration.ofMinutes(90);

		CM c = new CM(mat, ldt, bl, dur);
		Response responseAfterPost = target
				.path("calendar/cours/new")
				.request()
				.post(Entity.xml(c));

		assertEquals(200, responseAfterPost.getStatus());
	}
}
