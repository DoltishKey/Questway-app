<!DOCTYPE html>
<html>
 %include('head.tpl')
    <body>
        <main>
            %if user_autho == 1:
                % include('nav_students.tpl')
            %elif user_autho == 2:
                % include('nav_employers.tpl')
            %else:
                % include('nav.tpl')
            %end
            <div class="main_jubo">
                <div id="container_of_content">
                    <div class="container">
                        <h1 class="about_questway">ABOUT US</h1>
                        <h2 class=" "> We created Questway for the innovationsystem in southern Sweden.
                            For more people to use their skills and get in touch with each other.
                            There is no business model, everything is for free- we just love doing stuff!
                        </h2>
                        <ul>
                            <li>1. CREATE A QUEST FOR FREE</li>
                            <li>2. WAIT FOR PEOPLE TO APPLY</li>
                            <li>3. GET IN TOUCH WITH NEW COOL PEOPLE</li>
                        </ul>
                        <a href="/create_employer" class="btn red">JOIN US</a>
                    </div>
                </div>
                <div class="qw_team">
                    <h1>TEAM</h1>
                    <ul>
                        <li class="qw_team_profile">
                            <ul>
                                <h2>JACOB PETTERSSON</h2>
                                <li><div class="bckgrd"><h4>A true programmer who loves to fence!
                                        Started the company The Working generation in 2014.
                                        Is studying Information Architect at Malmö University.</h4></div></li>
                                <p>jacob.pettersson@questway.se</p>
                            </ul>
                        </li>
                        <li class="qw_team_profile">
                            <ul>
                                <h2>JARI ROSENSTRÖM</h2>
                                <li><div class="bckgrd"><h4>A creative homechef that runs his own consulting company.
                                        Is one of a kind when it comes to programming and is studying
                                        Information Architect at Malmö University.</h4></div></li>
                                <p>jari.rosenstrom@questway.se</p>
                            </ul>
                        </li>
                        <li class="qw_team_profile">
                            <ul>
                                <h2>JENNY SANDBERG</h2>
                                <li><div class="bckgrd"><h4>A crazy-cat-lady, musical fan and a squash player who started working in
                                        the local innovationsystem in 2013.
                                        Currently working as a business developer at Drivhuset Malmö.</h4></div></li>
                                <p>jenny.sandberg@questway.se</p>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
            %include('footer.tpl')
        </main>
    </body>
</html>
