module traffic_light (
    input  logic clk,
    input  logic rst,
    input  logic button,

    output logic carGreen,
    output logic carYellow,
    output logic carRed,

    output logic pedestrianGreen,
    output logic pedestrianRed
);

    typedef enum logic [1:0] {
        CAR_RED    = 2'd0,
        CAR_GREEN  = 2'd1,
        CAR_YELLOW = 2'd2
    } state_t;

    localparam logic [1:0] RED_DURATION    = 2'd3;
    localparam logic [1:0] GREEN_DURATION  = 2'd3;
    localparam logic [1:0] YELLOW_DURATION = 2'd2;

    state_t state;
    logic [1:0] counter;

    // FSM
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            state   <= CAR_RED;
            counter <= 2'd0;
        end
        else begin

            // Button pressed → hold current state
            if (button) begin
                state   <= state;
                counter <= counter;
            end
            else begin
                case (state)

                    CAR_RED: begin
                        if (counter == RED_DURATION - 1) begin
                            state   <= CAR_GREEN;
                            counter <= 2'd0;
                        end
                        else begin
                            counter <= counter + 1'b1;
                        end
                    end

                    CAR_GREEN: begin
                        if (counter == GREEN_DURATION - 1) begin
                            state   <= CAR_YELLOW;
                            counter <= 2'd0;
                        end
                        else begin
                            counter <= counter + 1'b1;
                        end
                    end

                    CAR_YELLOW: begin
                        if (counter == YELLOW_DURATION - 1) begin
                            state   <= CAR_RED;
                            counter <= 2'd0;
                        end
                        else begin
                            counter <= counter + 1'b1;
                        end
                    end

                    default: begin
                        state   <= CAR_RED;
                        counter <= 2'd0;
                    end

                endcase
            end
        end
    end

    // Output decode
    always_comb begin
        carRed          = 1'b0;
        carYellow       = 1'b0;
        carGreen        = 1'b0;
        pedestrianGreen = 1'b0;
        pedestrianRed   = 1'b1;

        case (state)

            CAR_RED: begin
                carRed          = 1'b1;
                pedestrianGreen = 1'b1;
                pedestrianRed   = 1'b0;
            end

            CAR_GREEN: begin
                carGreen      = 1'b1;
                pedestrianRed = 1'b1;
            end

            CAR_YELLOW: begin
                carYellow     = 1'b1;
                pedestrianRed = 1'b1;
            end

        endcase
    end

endmodule
